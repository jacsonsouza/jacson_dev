module Ai
  module Providers
    class GeminiProvider < Base
      BASE_URI = 'https://generativelanguage.googleapis.com/v1beta/models'.freeze

      def initialize(
        model: Rails.application.credentials.dig(:gemini, :model),
        api_key: Rails.application.credentials.dig(:gemini, :api_key)
      )
        super()
        @model = model
        @api_key = api_key
      end

      def stream(prompt, &block)
        validate!

        http = build_http
        request = build_request(prompt)

        http.request(request) do |response|
          yield_chunks(response, &block)
        end
      end

      private

      attr_reader :model, :api_key

      def build_http
        Net::HTTP.new(uri.host, uri.port).tap do |http|
          http.use_ssl = true
          http.open_timeout = 5
          http.read_timeout = 120
        end
      end

      def build_request(prompt)
        Net::HTTP::Post.new(uri, headers).tap do |req|
          req.body = body(prompt).to_json
        end
      end

      def yield_chunks(response)
        parser = Ai::Streaming::SseParser.new

        response.read_body do |chunk|
          parser.call(chunk) do |parsed|
            text = extract_text(parsed)
            yield text if text.present?
          end
        end
      end

      def body(prompt)
        {
          contents: [{ parts: [{ text: prompt }] }],
          generation_config: {
            temperature: 0.2,
            max_output_tokens: 400
          }
        }
      end

      def headers
        { 'Content-Type' => 'application/json' }
      end

      def uri
        URI("#{BASE_URI}/#{model}:streamGenerateContent?alt=sse&key=#{api_key}")
      end

      def extract_text(parsed)
        parsed
          .fetch('candidates', [])
          .flat_map { |c| c.dig('content', 'parts') || [] }
          .pluck('text')
          .compact
          .join
      end

      def validate!
        raise 'Missing API key' if api_key.blank?
        raise 'Missing model name' if model.blank?
      end
    end
  end
end
