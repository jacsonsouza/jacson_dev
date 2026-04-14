require 'application_system_test_case'

class AboutPageTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
  end

  test 'the visitant should access and see a chat' do
    visit about_path

    within '#ai-chat' do
      assert_text I18n.t('home.about.presentation')
      assert_selector 'form input[name="question"]'
      assert_selector 'form button[type="submit"]'
    end
  end

  test 'the visitant should access and see the operations section' do
    visit about_path

    within '#ai-operations' do
      %w[projects tech_stack new_project].each do |key|
        assert_text I18n.t("labels.#{key}").upcase
      end
    end
  end

  test 'the visitant can click on an operation and see the question in the chat input' do
    visit about_path

    within '#ai-operations' do
      click_on I18n.t('labels.projects')
    end

    within '#ai-chat' do
      assert_selector :field, 'question', with: I18n.t('ai.questions.projects')
    end
  end

  test 'the visitant can ask a question and see the answer' do
    visit about_path

    within '#ai-chat' do
      fill_in 'question', with: 'Talk about you.'
      click_button(type: 'submit')

      assert_text 'Jacson'
      assert_text 'Full Stack Developer'
    end
  end
end
