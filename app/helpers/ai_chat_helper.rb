module AiChatHelper
  DEFAULT_INTERACTIONS = [
    { icon: 'fa-bars-progress', question: 'Show me your main projects', label: 'Projects' },
    { icon: 'fa-microchip', question: 'What is Jacson\'s main tech stack?', label: 'Tech Stack' },
    { icon: 'fa-rocket', question: 'How can we start a project together?', label: 'New Project' }
  ].freeze

  def default_interactions = DEFAULT_INTERACTIONS
end
