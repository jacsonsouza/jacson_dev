module CapybaraCustomAssertions
  def assert_flash(message)
    within 'div#flash-message' do
      assert_selector '#flash-text', text: message
    end
  end
end