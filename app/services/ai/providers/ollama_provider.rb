# app/services/ai/providers/ollama_provider.rb
require 'net/http'
require 'json'

module Ai
  module Providers
    class OllamaProvider < Base
      DEFAULT_TIMEOUTS = {
        open: 5,
        read: 180,
        write: 30
      }.freeze

      def initialize(
        model: Rails.application.credentials.dig(:ollama, :model),
        base_url: Rails.application.credentials.dig(:ollama, :base_url)
      )
        super()
        @model = model
        @base_url = base_url
      end

      def stream(prompt, &block)
        return enum_for(:stream, prompt) unless block_given?

        http = build_http
        request = build_request(prompt)

        http.request(request) do |response|
          stream_response(response, &block)
        end
      end

      private

      attr_reader :model, :base_url

      def uri
        @uri ||= URI("#{base_url}/api/generate")
      end

      def build_http
        Net::HTTP.new(uri.host, uri.port).tap do |http|
          http.open_timeout = DEFAULT_TIMEOUTS[:open]
          http.read_timeout = DEFAULT_TIMEOUTS[:read]
          http.write_timeout = DEFAULT_TIMEOUTS[:write] if http.respond_to?(:write_timeout)
        end
      end

      def build_request(prompt)
        Net::HTTP::Post.new(uri, headers).tap do |req|
          req.body = body(prompt).to_json
        end
      end

      def headers
        { 'Content-Type' => 'application/json' }
      end

      def body(prompt)
        {
          model: model,
          prompt: prompt,
          stream: true,
          keep_alive: '15m',
          options: generation_config
        }
      end

      def generation_config
        {
          num_predict: 120,
          temperature: 0.3
        }
      end

      def stream_response(response, &)
        parser = Ai::Streaming::NdjsonParser.new

        response.read_body do |chunk|
          parser.call(chunk) do |parsed|
            text = parsed['response']
            yield text if text.present?
          end
        end
      end
    end
  end
end
