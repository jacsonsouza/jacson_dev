module IntegrationCustomAssertions
  def assert_error_message(message)
    assert_select 'p.text-red-500', text: message
  end

  def assert_access_to(paths)
    paths.each do |path|
      get path

      assert_response :success
    end
  end

  def assert_no_access_to(paths)
    paths.each do |path|
      get path

      assert_response :redirect
    end
  end
end
