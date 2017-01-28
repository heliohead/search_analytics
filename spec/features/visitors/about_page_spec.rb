# Feature: About page
#   As a visitor
#   I want to visit a about page
#   So I can learn more about the website
feature 'About page' do

  # Scenario: Visit the about page
  #   Given I am a visitor
  #   When I visit the about page
  #   Then I see "Welcome"
  scenario 'visit the about page' do
    visit about_path
    expect(page).to have_content 'Search Analytics'
    expect(page).to have_content 'About'
  end

end
