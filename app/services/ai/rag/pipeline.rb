class Ai::Rag::Pipeline
  def initialize
    @prompt_builder = Ai::Rag::PromptBuilder.new
    @context_formatter = Ai::Rag::ContextFormatter.new
  end

  def call(question:)
    prompt_builder.call(question:, context: cached_context)
  end

  private

  attr_reader :prompt_builder, :context_formatter

  def cached_context
    Rails.cache.fetch('rag/context', **cache_options) do
      user = user_context

      context_formatter.call(
        profile: user,
        skills: user.skills,
        projects: user.projects
      )
    end
  end

  def cache_options
    {
      expires_in: 30.minutes,
      race_condition_ttl: 10.seconds,
      compress: true
    }
  end

  def user_context
    User.includes(:skills, :projects).sole
  end
end
