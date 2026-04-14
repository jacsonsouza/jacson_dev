# app/services/ai/providers/static_provider.rb
module Ai
  module Providers
    class StaticProvider < Base
      TOKEN_DELAY = 0.035

      CLASSIFICATION_RULES = [
        { key: :projects, pattern: /project|portfolio/ },
        { key: :stack, pattern: /stack|tech/ },
        { key: :work, pattern: /hire|freelance/ },
        { key: :about, pattern: /about|who are you/ }
      ].freeze

      def initialize(config: Rails.application.config_for(:jacson_ai))
        super()
        @config = config.to_h.deep_symbolize_keys
      end

      def stream(prompt, &)
        return enum_for(:stream, prompt) unless block_given?

        response = resolve_response(prompt)

        stream_tokens(response, &)
      end

      private

      attr_reader :config

      def resolve_response(prompt)
        key = classify(prompt)
        Rails.logger.info("StaticProvider classified question as: #{key} - #{prompt}")
        config.fetch(key, config[:default])
      end

      def classify(text)
        question = text.match(/Question: (.*)/)[1]
        normalized = question.downcase

        CLASSIFICATION_RULES
          .find { |rule| normalized.match?(rule[:pattern]) }
          &.dig(:key) || :default
      end

      def stream_tokens(text)
        text.split(/\s+/).each do |token|
          yield "#{token} "
          sleep TOKEN_DELAY
        end
      end
    end
  end
end
