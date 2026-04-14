require 'test_helper'

class Ai::Rag::PipelineTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @skill = create(:skill, user: @user)
    @project = create(:project, user: @user)

    @pipeline = Ai::Rag::Pipeline.new
  end

  test 'should builds prompt with user context' do
    prompt = @pipeline.call(question: 'IA')

    assert_includes prompt, @user.name
  end

  test 'should builds prompt with project context' do
    prompt = @pipeline.call(question: 'IA')

    assert_includes prompt, @project.name
    assert_includes prompt, @project.short_description
  end

  test 'should builds prompt with skill context' do
    prompt = @pipeline.call(question: 'IA')

    assert_includes prompt, @skill.name
  end
end
