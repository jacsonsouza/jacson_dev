class Dashboard::ProjectSkillDistribution
  def call
    Project.joins(:skills).group('skills.name').count
  end
end
