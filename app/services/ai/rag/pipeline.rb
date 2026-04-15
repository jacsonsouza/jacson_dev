class Ai::Rag::Pipeline
  def initialize
    @prompt_builder = Ai::Rag::PromptBuilder.new
    @context_formatter = Ai::Rag::ContextFormatter.new
  end

  def call(question:)
    prompt_builder.call(question:, context: context)
  end

  private

  attr_reader :prompt_builder, :context_formatter

  def context
    user = user_context

    context_formatter.call(
      profile: user,
      skills: user.skills,
      projects: user.projects
    )
  end

  def user_context
    User.includes(:skills, :projects).sole
  end
end
