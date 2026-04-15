module AiChatHelper
  DEFAULT_INTERACTIONS = [
    { icon: 'fa-bars-progress', question: I18n.t('ai.questions.projects'), label: I18n.t('labels.projects') },
    { icon: 'fa-microchip', question: I18n.t('ai.questions.skills'), label: I18n.t('labels.tech_stack') },
    { icon: 'fa-rocket', question: I18n.t('ai.questions.work_together'), label: I18n.t('labels.new_project') }
  ].freeze

  def default_interactions = DEFAULT_INTERACTIONS
end
