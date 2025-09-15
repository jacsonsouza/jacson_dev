# frozen_string_literal: true

class Flash::MessageComponent < ViewComponent::Base
  def messages
    helpers.flash.delete(:timedout)
  end

  def flash_title(flash_type)
    {
      notice: "Success",
      alert: "Error"
    }[flash_type.to_sym]
  end

  def class_type(flash_type)
    {
      notice: "border-l-green-500",
      alert: "border-l-red-500"
    }[flash_type.to_sym] || "alert-#{flash_type}"
  end

  def icon(flash_type)
    {
      notice: "check-circle text-green-500",
      alert: "exclamation-circle text-red-500"
    }[flash_type.to_sym]
  end

  def progress(flash_type)
    {
      notice: "bg-green-500",
      alert: "bg-red-500"
    }[flash_type.to_sym]
  end
end
