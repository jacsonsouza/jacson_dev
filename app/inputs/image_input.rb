class ImageInput < SimpleForm::Inputs::Base
  DEFAULT_IMAGE = 'default_pic.png'.freeze
  CONTROLLER = 'image-input'.freeze
  ACCEPTED_TYPES = 'image/png, image/jpeg'.freeze

  def input(wrapper_options = nil)
    template.content_tag :div, wrapper_attributes do
      preview_container + upload_area(wrapper_options)
    end
  end

  private

  def preview_container
    content_tag :div, preview_attributes do
      content_tag(:div, class: 'w-full h-full p-6 flex items-center justify-center') do
        content_tag(:div, class: 'relative h-full aspect-[3/4]') do
          preview_image + remove_button
        end
      end
    end
  end

  def upload_area(wrapper_options)
    template.content_tag :label, upload_label_attrs do
      upload_content + @builder.file_field(attribute_name, input_options(wrapper_options))
    end
  end

  def input_options(wrapper_options)
    merge_wrapper_options(input_html_options, wrapper_options).tap do |opts|
      opts[:class] = [opts[:class], 'hidden'].compact.join(' ')
      opts[:accept] = ACCEPTED_TYPES
      opts[:data] = { "#{CONTROLLER}-target": 'input', action: 'change->input-image#loadFile' }
    end
  end

  def wrapper_attributes
    {
      class: 'relative w-full h-64 border-2 border-dashed border-gray-700 rounded-lg bg-gray-800',
      data: { controller: CONTROLLER }
    }
  end

  def preview_image
    template.image_tag(
      image_url,
      data: { "#{CONTROLLER}-target": 'previewImage' },
      class: 'w-full h-full object-cover rounded-xl shadow-lg'
    )
  end

  def image_url
    return default_image unless valid_attachment?

    Rails.application.routes.url_helpers.rails_blob_url(attachment.blob, only_path: true)
  rescue StandardError
    default_image
  end

  def upload_content
    template.content_tag :div, class: 'text-center px-4' do
      template.content_tag(:i, '', class: 'fas fa-cloud-upload-alt fa-3x mb-6 text-gray-400') +
        template.content_tag(:p, 'Click to upload', class: 'mb-3 text-sm text-gray-500 font-semibold')
    end
  end

  def remove_button
    template.button_tag(
      'X',
      type: 'button',
      class: 'absolute top-2 right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center',
      data: { action: "#{CONTROLLER}#removeImage" }
    )
  end

  def preview_attributes
    {
      class: "w-full h-full #{'hidden' unless valid_attachment?}",
      data: { "#{CONTROLLER}-target": 'previewContainer' }
    }
  end

  def upload_label_attrs
    classes = 'absolute inset-0 flex flex-col items-center justify-center rounded-lg cursor-pointer hover:bg-gray-700'
    {
      class: "#{classes} #{'hidden' if valid_attachment?}",
      data: { "#{CONTROLLER}-target": 'defaultContent' }
    }
  end

  def valid_attachment?
    @valid_attachment ||= object.persisted? && object.send(attribute_name).attached?
  end

  def default_image
    ActionController::Base.helpers.asset_path(DEFAULT_IMAGE)
  end
end
