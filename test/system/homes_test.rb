require 'application_system_test_case'

class HomesTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit root_path
  
    assert_selector 'h1', text: 'Estamos trabalhando nisso'
    assert_selector 'p', text: 'Esta página está em construção. Em breve teremos novidades por aqui!'
  end
end
