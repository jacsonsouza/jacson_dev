module ApplicationHelper
  def rc(component_string, **args)
    component_class_name = component_string.split('\\').map(&:camelcase).join('::')
    render "#{component_class_name}Component".constantize.new(**args)
  end

  def full_title(page_title = '', base_title = t('app.name'))
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def nav_items
    [
      { name: t('links.home'), icon: 'fas fa-home', path: root_path },
      { name: t('links.projects'), icon: 'fas fa-briefcase', path: projects_path },
      { name: t('links.skills'), icon: 'fas fa-code', path: skills_path },
      { name: t('links.about'), icon: 'fas fa-user', path: about_path },
      { name: t('links.contact'), icon: 'fas fa-envelope', path: contact_path }
    ]
  end
end
