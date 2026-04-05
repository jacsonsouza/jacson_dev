require 'net/http'
require 'json'

module Ai
  module Providers
    class OllamaProvider < Base
      def initialize(model: ENV.fetch('OLLAMA_MODEL', 'phi3:mini'))
        super()
        @model = model
      end

      def stream(question, &block)
        uri = URI("#{base_url}/api/generate")
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 5
        http.read_timeout = 180
        http.write_timeout = 30 if http.respond_to?(:write_timeout)
        request = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })

        request.body = {
          model: model,
          prompt: build_prompt(question),
          stream: true,
          keep_alive: '15m',
          options: {
            num_predict: 120,
            temperature: 0.3
          }
        }.to_json

        buffer = +''

        http.request(request) do |response|
          response.read_body do |chunk|
            buffer << chunk

            while (line = buffer.slice!(/.*\n/))
              parsed = begin
                JSON.parse(line)
              rescue StandardError
                nil
              end
              next unless parsed

              content = parsed['response']
              block.call(content) if content.present?
            end
          end
        end
      end

      private

      attr_reader :model

      def base_url
        ENV.fetch('OLLAMA_URL', 'http://ollama:11434')
      end

      def build_prompt(question)
        <<~PROMPT
          You are Jacson AI, an assistant embedded in Jacson's portfolio website.

          Your job:
          - Answer questions about Jacson's professional profile
          - Be concise, clear, and professional
          - Do not invent experience or technologies
          - If information is unknown, say so honestly

          Portfolio context:
          - Jacson is a Full Stack Developer
          - Main stack: Laravel, React, Ruby on Rails, React Native
          - Focus: robust web applications, maintainable systems, clean architecture
          - Highlight: built a reporting system that reduced a monthly process from 30 hours to 30 minutes

          User question:
          #{question}
        PROMPT
      end
    end
  end
end
