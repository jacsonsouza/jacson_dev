require 'test_helper'

class SafeExternalUrlTest < ActionView::TestCase
  include ApplicationHelper

  test 'should permit http Urls' do
    assert_equal 'http://example.com', safe_external_url('http://example.com')
  end

  test 'should permit https Urls' do
    assert_equal 'https://example.com', safe_external_url('https://example.com')
  end

  test 'should reject data: Urls' do
    assert_nil safe_external_url('data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==')
  end

  test 'should reject javascript: Urls' do
    assert_nil safe_external_url('javascript:alert("XSS")')
  end

  test 'should reject invalid Urls' do
    assert_nil safe_external_url('http://example.com/invalid|url')
  end

  test 'should return nil for non-string input' do
    assert_nil safe_external_url(12_345)
  end

  test 'should return nil for empty string' do
    assert_nil safe_external_url('')
  end

  test 'should return nil for nil input' do
    assert_nil safe_external_url(nil)
  end

  test 'should return nil for blank input' do
    assert_nil safe_external_url('   ')
  end
end
