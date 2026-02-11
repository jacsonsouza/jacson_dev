module Users::ProjectsHelper
  def project_action_links(project)
    [
      { icon: 'fas fa-code', url: project.repository, target: '_blank' },
      { icon: 'fas fa-external-link-alt', url: project.url, target: '_blank' },
      { icon: 'fas fa-pen', url: edit_users_project_path(project), data: { turbo: false } },
      { icon: 'fas fa-trash', url: users_project_path(project),
        data: { turbo_method: :delete, turbo_confirm: t('.confirm') } },
      { icon: 'fas fa-info', url: users_project_path(project) }
    ]
  end

  def project_development_time(project)
    t(
      'time.development',
      time: distance_of_time_in_words(project.start_date, project.end_date)
    )
  end
end
