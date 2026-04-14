require 'test_helper'

class Ai::ChatTest < ActiveSupport::TestCase
  def setup
    user = create(:user)
    create(:skill, user: user)
    create(:project, user: user)
  end

  test 'should streams response using provider' do
    chat = Ai::Chat.new(provider: fake_provider)

    chunks = []
    chat.stream('test') { |c| chunks << c }

    assert_equal ['Hello', ' World'], chunks
  end

  private

  def fake_provider
    Class.new do
      def stream(_prompt)
        yield 'Hello'
        yield ' World'
      end
    end.new
  end
end
