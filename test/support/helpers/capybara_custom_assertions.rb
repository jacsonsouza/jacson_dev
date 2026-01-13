module CapybaraCustomAssertions
  def assert_flash(message)
    within 'div#flash-message' do
      assert_selector '#flash-text', text: message
    end
  end

  def assert_input_error(attribute, message)
    within "div.#{attribute}" do
      assert_selector 'p.text-red-500', text: message
    end
  end
end
