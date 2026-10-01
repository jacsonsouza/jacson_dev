module CapybaraCustomAssertions
  def assert_flash(message)
    assert_selector 'div#flash-message #flash-text', text: message
  end

  def assert_input_error(attribute, message)
    within "div.#{attribute}" do
      assert_selector 'p.text-danger', text: message
    end
  end
end
