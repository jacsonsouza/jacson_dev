module AiChatHelper
  DEFAULT_INTERACTIONS = [
    { icon: :bars_progress, question: I18n.t('ai.questions.projects'), label: I18n.t('labels.projects') },
    { icon: :microchip, question: I18n.t('ai.questions.skills'), label: I18n.t('labels.tech_stack') },
    { icon: :rocket, question: I18n.t('ai.questions.work_together'), label: I18n.t('labels.new_project') }
  ].freeze

  def default_interactions = DEFAULT_INTERACTIONS
end
