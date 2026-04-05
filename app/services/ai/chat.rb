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
      case ENV.fetch('AI_PROVIDER', 'gemini')
      when 'gemini'
        Ai::Providers::GeminiProvider.new
      when 'ollama'
        Ai::Providers::OllamaProvider.new
      else
        Ai::Providers::StaticProvider.new
      end
    end

    def build_prompt(question, context)
      {
        question: question,
        context: context
      }
    end
  end
end
