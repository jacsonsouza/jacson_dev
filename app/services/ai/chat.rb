module Ai
  class Chat
    def initialize(provider: default_provider)
      @provider = provider
    end

    def stream(question, &)
      user = User.includes(:skills, :projects).first
      context = Ai::ContextBuilder.new(user:).build

      prompt = build_prompt(question, context)

      @provider.stream(prompt, &)
    end

    private

    def default_provider
      provider = Rails.application.credentials.dig(:ai, :provider).to_s.camelize

      "Ai::Providers::#{provider}Provider".constantize.new
    rescue NameError
      Providers::StaticProvider.new
    end

    def build_prompt(question, context)
      {
        question: question,
        context: context
      }
    end
  end
end
