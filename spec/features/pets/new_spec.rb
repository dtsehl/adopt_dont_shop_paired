require 'rails_helper'

RSpec.describe "Creating a new Pet" do
  it "creates a new pet for an shelter" do
    shelter_1 = Shelter.create!(name: "Joe's Shelter", address: "123 Apple St.", city: "Denver", state: "CO", zip: 80202)

    visit "/shelters/#{shelter_1.id}/pets"

    within '.clickables' do
      expect(page).to have_content("Create Pet")
      click_on "Create Pet"
    end

    expect(current_path).to eq("/shelters/#{shelter_1.id}/pets/new")

    name = "Fido"
    description = "A furry Friend"
    approx_age = 3
    sex = "Female"
    image = "https://homepages.cae.wisc.edu/~ece533/images/cat.png"

    within '.form' do
      expect(page).to have_content("Name")
      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :approx_age, with: approx_age
      fill_in :sex, with: sex
      fill_in :image, with: image
      click_button "Create Pet"
    end

    new_pet = Pet.last

    expect(current_path).to eq("/shelters/#{shelter_1.id}/pets")

    within '.pet-details' do
      expect(page).to have_content(name)
      expect(page).to have_content(approx_age)
      expect(page).to have_content(description)
      expect(page).to have_content(sex)
      expect(page).to have_content(new_pet.adoptable?)
    end
  end

  it "shows flash message for incomplete information" do
    shelter_1 = Shelter.create!(name: "Joe's Shelter", address: "123 Apple St.", city: "Denver", state: "CO", zip: 80202)

    visit "/shelters/#{shelter_1.id}/pets"

    within '.clickables' do
      expect(page).to have_content("Create Pet")
      click_on "Create Pet"
    end

    expect(current_path).to eq("/shelters/#{shelter_1.id}/pets/new")

    name = "Fido"
    description = "A furry Friend"
    image = "https://homepages.cae.wisc.edu/~ece533/images/cat.png"

    within '.form' do
      expect(page).to have_content("Name")
      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :image, with: image
      click_button "Create Pet"
    end

    expect(current_path).to eq("/shelters/#{shelter_1.id}/pets/new")

    within '.messages' do
      expect(page).to have_content("Sex can't be blank")
      expect(page).to have_content("Approx age can't be blank")
    end
  end
end
