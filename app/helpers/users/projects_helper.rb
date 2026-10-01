module Users::ProjectsHelper
  def project_action_links(project)
    [
      { icon: :code, url: project.repository, target: '_blank' },
      { icon: :up_right_from_square, url: project.url, target: '_blank' },
      { icon: :pen, url: edit_users_project_path(project), data: { turbo: false } },
      { icon: :trash, url: users_project_path(project),
        data: { turbo_method: :delete, turbo_confirm: t('.confirm') } },
      { icon: :circle_info, url: users_project_path(project) }
    ]
  end

  def project_development_time(project)
    t(
      'time.development',
      time: distance_of_time_in_words(project.start_date, project.end_date)
    )
  end
end
