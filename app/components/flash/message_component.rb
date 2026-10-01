# frozen_string_literal: true

class Flash::MessageComponent < ViewComponent::Base
  FLASH_CONFIG = {
    notice: {
      title: 'Success',
      class: 'border-l-success',
      icon: :circle_check,
      icon_class: 'text-success',
      progress: 'bg-success'
    },
    alert: {
      title: 'Error',
      class: 'border-l-danger',
      icon: :circle_exclamation,
      icon_class: 'text-danger',
      progress: 'bg-danger'
    },
    warning: {
      title: 'Warning',
      class: 'border-l-yellow-500',
      icon: :triangle_exclamation,
      icon_class: 'text-yellow-500',
      progress: 'bg-yellow-500'
    }
  }.freeze

  DEFAULT_CONFIG = {
    title: 'Info',
    class: 'border-l-subtle',
    icon: :circle_info,
    icon_class: 'text-subtle',
    progress: 'bg-subtle'
  }.freeze

  def messages
    helpers.flash.delete(:timedout)
  end

  def flash_title(flash_type)
    config_for(flash_type)[:title]
  end

  def class_type(flash_type)
    config_for(flash_type)[:class]
  end

  def icon_name(flash_type)
    config_for(flash_type)[:icon]
  end

  def icon_class(flash_type)
    config_for(flash_type)[:icon_class]
  end

  def progress(flash_type)
    config_for(flash_type)[:progress]
  end

  private

  def config_for(flash_type)
    FLASH_CONFIG.fetch(flash_type.to_sym, DEFAULT_CONFIG)
  end
end
