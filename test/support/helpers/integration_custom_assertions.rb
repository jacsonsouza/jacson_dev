module IntegrationCustomAssertions
  def assert_error_message(message)
    assert_select "p.text-red-500", text: message
  end
end
