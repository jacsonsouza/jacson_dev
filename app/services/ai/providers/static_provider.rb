module Ai
  module Providers
    class StaticProvider < Base
      def initialize(config: Rails.application.config_for(:jacson_ai))
        super()
        @config = config.to_h.deep_symbolize_keys
      end

      def stream(question, &block)
        response = response_for(question)

        response.split(/\s+/).each do |token|
          block.call("#{token} ")
          sleep 0.035
        end
      end

      private

      attr_reader :config

      def response_for(question)
        normalized = question.to_s.downcase

        key =
          case normalized
          when /project|projects|portfolio/
            :projects
          when /stack|tech|technology|technologies/
            :stack
          when /hire|work|project together|start project|freelance|contact/
            :work
          when /about|who are you|who is jacson|tell me about yourself/
            :about
          else
            :default
          end

        config.fetch(key)
      end
    end
  end
end
