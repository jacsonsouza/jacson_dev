class Ai::Chat
  def initialize(provider: default_provider, pipeline: default_pipeline)
    @provider = provider
    @pipeline = pipeline
  end

  def stream(question, &)
    prompt = pipeline.call(question: question)

    provider.stream(prompt, &)
  end

  private

  attr_reader :provider, :pipeline

  def default_provider
    provider = Rails.application.credentials.dig(:ai, :provider).to_s.camelize

    "Ai::Providers::#{provider}Provider".constantize.new
  rescue NameError
    Providers::StaticProvider.new
  end

  def default_pipeline
    Ai::Rag::Pipeline.new
  end
end
