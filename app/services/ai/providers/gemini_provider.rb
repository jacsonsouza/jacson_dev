# app/services/ai/providers/gemini_provider.rb
require 'net/http'
require 'json'
require 'uri'

module Ai
  module Providers
    class GeminiProvider < Base
      def initialize(
        model: Rails.application.credentials.dig(:gemini, :model),
        api_key: Rails.application.credentials.dig(:gemini, :api_key)
      )
        @model = model
        @api_key = api_key
      end

      def stream(question, &block)
        raise 'Gemini API key is missing.' if @api_key.blank?

        uri = URI(
          "https://generativelanguage.googleapis.com/v1beta/models/#{@model}:streamGenerateContent?alt=sse&key=#{@api_key}"
        )

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.open_timeout = 5
        http.read_timeout = 120
        http.write_timeout = 30 if http.respond_to?(:write_timeout)

        request = Net::HTTP::Post.new(uri, {
                                        'Content-Type' => 'application/json'
                                      })

        request.body = {
          contents: [
            {
              parts: [
                {
                  text: build_prompt(question)
                }
              ]
            }
          ],
          generationConfig: {
            temperature: 0.2,
            maxOutputTokens: 400
          }
        }.to_json

        buffer = +''

        http.request(request) do |response|
          response.read_body do |chunk|
            buffer << chunk

            while (line = buffer.slice!(/.*\n/))
              line = line.strip
              next if line.blank?
              next unless line.start_with?('data:')

              payload = line.delete_prefix('data:').strip
              next if payload.blank?

              parsed = begin
                JSON.parse(payload)
              rescue StandardError
                nil
              end
              next unless parsed

              text = extract_text(parsed)
              block.call(text) if text.present?
            end
          end
        end
      end

      private

      def build_prompt(question)
        skills = question[:context][:skills].pluck(0).join(', ')
        projects = question[:context][:projects].map { |name, desc| "- #{name}: #{desc}" }.join("\n")

        <<~PROMPT
          <role>
          You are the virtual assistant for #{question[:context][:profile][:name]}'s developer portfolio. 
          Your personality: Professional, helpful, and tech-savvy.
          </role>

          <technical_context>
          - Main Stack: #{skills}
          - Focus: Clean Architecture and sustainable web applications.
          - Key Projects:
          #{projects}
          </technical_context>

          <golden_rules>
          1. Always respond in the same language the user used to ask the question.
          2. If you don't know something about #{question[:context][:profile][:name]}, politely state that you don't have that information. Never invent facts (no hallucinations).
          3. Be concise (maximum 3 paragraphs).
          4. Use Markdown to format your response (bolding, lists, etc.).
          </golden_rules>

          User Question: "#{question[:question]}"
        PROMPT
      end

      def extract_text(parsed)
        candidates = parsed['candidates']
        return nil unless candidates.is_a?(Array)

        parts = candidates.flat_map do |candidate|
          content = candidate['content']
          next [] unless content.is_a?(Hash)

          content_parts = content['parts']
          next [] unless content_parts.is_a?(Array)

          content_parts.map { |part| part['text'] }.compact
        end

        parts.join
      end
    end
  end
end
