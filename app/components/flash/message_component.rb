# frozen_string_literal: true

class Flash::MessageComponent < ViewComponent::Base
  FLASH_CONFIG = {
    notice: {
      title: 'Success',
      class: 'border-l-green-500',
      icon: 'check-circle text-green-500',
      progress: 'bg-green-500'
    },
    alert: {
      title: 'Error',
      class: 'border-l-red-500',
      icon: 'exclamation-circle text-red-500',
      progress: 'bg-red-500'
    },
    warning: {
      title: 'Warning',
      class: 'border-l-yellow-500',
      icon: 'exclamation-triangle text-yellow-500',
      progress: 'bg-yellow-500'
    }
  }.freeze

  DEFAULT_CONFIG = {
    title: 'Info',
    class: 'border-l-gray-500',
    icon: 'info-circle text-gray-500',
    progress: 'bg-gray-500'
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

  def icon(flash_type)
    config_for(flash_type)[:icon]
  end

  def progress(flash_type)
    config_for(flash_type)[:progress]
  end

  private

  def config_for(flash_type)
    FLASH_CONFIG.fetch(flash_type.to_sym, DEFAULT_CONFIG)
  end
end
