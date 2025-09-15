module ApplicationHelper
  def rc(component_string, **args)
    component_class_name = component_string.split('\\').map(&:camelcase).join('::')
    render "#{component_class_name}Component".constantize.new(**args)
  end
end
