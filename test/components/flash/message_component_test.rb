# frozen_string_literal: true

require "test_helper"

class Flash::MessageComponentTest < ViewComponent::TestCase
  def setup
    @controller_class = HomeController
  end

  def test_renders_nothing_when_no_messages
    render_component
    assert_no_selector ".flash-item"
  end

  def test_renders_notice_message_with_correct_content_and_styles
    success_message = "Operation completed successfully!"
    render_component(notice: success_message)

    assert_selector ".fa-check-circle"
    assert_selector ".bg-green-500"
    assert_selector "#flash-text", text: success_message
  end

  def test_renders_alert_message_with_correct_styling
    error_message = "Error processing request."
    render_component(alert: error_message)

    assert_selector ".fa-exclamation-circle"
    assert_selector ".bg-red-500"
    assert_selector "#flash-text", text: error_message
  end

  def test_renders_warning_message_with_correct_styling
    warning_message = "Warning: please check the data."
    render_component(warning: warning_message)

    assert_selector ".fa-exclamation-triangle"
    assert_selector ".bg-yellow-500"
    assert_selector "#flash-text", text: warning_message
  end

  def test_renders_multiple_messages
    render_component(
      notice: "Success message",
      alert: "Error message",
      warning: "Warning message"
    )

    assert_selector "[data-flash-type='notice']"
    assert_selector "[data-flash-type='alert']"
    assert_selector "[data-flash-type='warning']"
  end

  def test_ignores_timedout_flash
    real_message = "Operation completed successfully!"
    ignored_message = "Timedout message that should be ignored"

    render_component(
      notice: real_message,
      timedout: ignored_message
    )

    assert_selector ".flash-item", count: 1
    assert_text real_message
    assert_no_text ignored_message
  end

  def test_sanitizes_html_content
    render_component(notice: "Important <strong>text</strong> <script>alert('xss')</script>")

    assert_selector "strong", text: "text"
    assert_no_selector "script"
    assert_text "Important text"
  end

  def test_unknown_flash_type_uses_default_styling
    render_component(custom_type: "Custom message")

    assert_text "Info"
    assert_selector ".bg-gray-500"
    assert_selector ".fa-info-circle"
  end

  private

  def render_component(flash_messages = {})
    with_controller_class @controller_class do
      flash_messages.each do |type, message|
        vc_test_controller.flash[type] = message
      end
      render_inline(Flash::MessageComponent.new)
    end
  end
end
