require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:identity)
    should validate_length_of(:identity).is_at_least(3).is_at_most(50)
    should validate_presence_of(:email)
    should allow_value('YHjS8@example.com').for(:email)
    should_not allow_value('invalid-email').for(:email)
    should validate_presence_of(:subject)
    should validate_length_of(:subject).is_at_least(5).is_at_most(255)
    should validate_presence_of(:content)
    should validate_length_of(:content).is_at_least(10).is_at_most(1000)
  end
end
