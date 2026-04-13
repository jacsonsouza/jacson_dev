class Ai::Rag::ContextFormatter
  def call(projects:, skills:, profile:)
    <<~TEXT
      Profile:
      #{profile.name}

      Skills:
      #{skills.map(&:name).join(', ')}

      Projects:
      #{projects.map { |p| "- #{p.name}: #{p.short_description}" }.join("\n")}
    TEXT
  end
end
