class ColorInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    @current_value = object.public_send(attribute_name) || '#000000'
    hex_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.content_tag(:div, class: 'relative', data: { controller: 'color' }) do
      hexadecimal_builder(hex_options) + swatch + color_preview_builder
    end
  end

  private

  def hexadecimal_builder(hex_options = {})
    @builder.text_field(
      attribute_name,
      hex_options.merge(
        value: @current_value,
        data: { 'color-target': 'hex', action: 'input->color#hexChanged' },
        class: "w-full h-11 pl-3 pr-14 bg-gray-800 border border-gray-700
                rounded-lg text-white placeholder-gray-400
                focus:ring-2 focus:ring-purple-500 focus:border-purple-500 transition"
      )
    )
  end

  def color_preview_builder
    @builder.color_field(
      attribute_name,
      value: @current_value,
      data: { 'color-target': 'picker', action: 'input->color#pickerChanged' },
      class: 'absolute right-1 top-1 w-9/10 h-full opacity-0 cursor-pointer'
    )
  end

  def swatch
    template.content_tag(
      :div,
      '',
      class: 'absolute right-1 top-1 w-9 h-9 rounded-md border border-gray-600 pointer-events-none',
      data: { 'color-target': 'swatch' },
      style: "background-color: #{@current_value}"
    )
  end
end
