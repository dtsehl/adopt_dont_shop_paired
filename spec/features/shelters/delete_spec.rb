require 'rails_helper'

RSpec.describe 'When I visit the shelter show details page' do
  it "I can destroy a shelter" do
    shelter_1 = Shelter.create(name: "Joe's Shelter", address: "123 Apple St.", city: "Denver", state: "CO", zip: 80202)

    visit "/shelters/#{shelter_1.id}"

    within '.shelter-details' do
      expect(page).to have_content("Joe's Shelter")
    end

    within '.clickables' do
      expect(page).to have_button("Delete Shelter")
      click_button "Delete Shelter"
    end

    expect(current_path).to eq("/shelters")
    expect(page).to_not have_content("Joe's Shelter")
  end

  it "cannot delete a shelter if one of its pets has pending status" do
    shelter_1 = Shelter.create!(name: "Joe's Shelter", address: "123 Apple St.", city: "Denver", state: "CO", zip: 80202)
    pet_1 = shelter_1.pets.create!(image: "/Users/dan/turing/2module/adopt_dont_shop_2005/app/assets/images/afghanhound_dog_pictures_.jpg", name: "Fido", approx_age: 3, sex: "F", shelter_name: shelter_1.name, description: "A furry friend!", status: true)
    pet_2 = shelter_1.pets.create!(image: "/Users/dan/turing/2module/adopt_dont_shop_2005/app/assets/images/husky_sideways_dog_pictures_.jpg", name: "Zorba", approx_age: 2, sex: "M", shelter_name: shelter_1.name, status: true)
    application1 = Application.create!(name: "Bob", address: "123 Fake St", city: "San Diego", state: "CA", zip: 92126, phone: "123-456-7890", description: "I love animals!")
    PetApplication.create(pet: pet_1, application: application1)
    PetApplication.create(pet: pet_2, application: application1)

    visit "/shelters/#{shelter_1.id}"

    within '.clickables' do
      expect(page).to have_button("Delete Shelter")
    end

    visit "/applications/#{application1.id}"

    within "#pet-#{pet_1.id}" do
      click_on "Approve Application"
    end

    visit "/shelters/#{shelter_1.id}"

    within '.clickables' do
      expect(page).to_not have_button("Delete Shelter")
    end
  end
end
