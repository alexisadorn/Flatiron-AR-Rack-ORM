require_relative 'spec_helper'

describe "CostumeStore" do

  it "has a name" do
    spirit_halloween = CostumeStore.create(
      name: "Spirit Halloween"
    )
    expect(CostumeStore.find_by(name: "Spirit Halloween")).to eq(spirit_halloween)
  end

  it "has a location" do
    abracadabra = CostumeStore.create(
      location: "19 W 21st St"
    )
    expect(CostumeStore.find_by(location: "19 W 21st St")).to eq(abracadabra)
  end

  it "has a costume inventory" do
    adventure = CostumeStore.create(
      costume_inventory: 785
    )
    expect(CostumeStore.find_by(costume_inventory: 785)).to eq(adventure)
  end

  it "has an employees count" do
    rickys = CostumeStore.create(
      name: "Ricky’s", 
      location: "375 Broadway",
      costume_inventory: 650,
      num_of_employees: 17
    )
    expect(CostumeStore.find_by(num_of_employees: 17)).to eq(rickys)
  end

  it "knows if it's still in business or permanently closed" do
    CostumeStore.create(
      name: "Frankie", 
      location: "580 Broadway",
      still_in_business: true
    )
    CostumeStore.create(
      name: "Spirit",
      location: "105 Amsterdam Ave",
      still_in_business: false      
    )
    expect(CostumeStore.find_by(name: "Frankie").still_in_business).to eq(true)
    expect(CostumeStore.find_by(name: "Spirit").still_in_business).to eq(false)
  end

  it "has an opening time" do
    start_time = get_opening_time
    creative = CostumeStore.create(
      name: "Creative Costume Co", 
      opening_time: start_time 
    )
    expect(CostumeStore.find_by(name: "Creative Costume Co").opening_time).to eq(start_time)
  end

  it "has a closing time" do
    end_time = get_closing_time
    ny_costumes = CostumeStore.create(
      name: "New York Costumes", 
      closing_time: end_time 
    )
    expect(CostumeStore.find_by(name: "New York Costumes").closing_time).to eq(end_time)
  end

end
