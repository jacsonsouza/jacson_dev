require 'test_helper'

class AiChatControllerTest < ActionDispatch::IntegrationTest
  def setup
    user = create(:user)
    create(:skill, user: user)
    create(:project, user: user)
  end

  test 'should returns success for valid question' do
    get ai_chat_stream_path, params: { question: 'test' }

    assert_response :success
  end
end
