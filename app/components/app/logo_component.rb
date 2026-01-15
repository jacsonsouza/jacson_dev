# frozen_string_literal: true

class App::LogoComponent < ViewComponent::Base
  def initialize(text_class: nil, icon_class: nil)
    super()
    @text_class = text_class
    @icon_class = icon_class
  end

  def text_class
    "font-bold text-2xl text-primary text-center
     flex items-center justify-center gap-2.5 #{@text_class}".strip
  end

  def icon_class
    "h-7 #{@icon_class}".strip
  end
end
