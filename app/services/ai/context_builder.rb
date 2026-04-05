module Ai
  class ContextBuilder
    def initialize(user:)
      @user = user
    end

    def build
      {
        profile: profile_data,
        skills: skills_data,
        projects: projects_data
      }
    end

    private

    attr_reader :user

    def profile_data
      {
        name: user.name,
        email: user.email
      }
    end

    def skills_data
      user.skills.pluck(:name, :proficiency)
    end

    def projects_data
      user.projects.pluck(:name, :short_description)
    end
  end
end
