require_relative 'spec_helper'

describe "HauntedHouse" do

  it "has a name" do
    asylum = HauntedHouse.create(
      name: "Asylum Haunted House"
    )
    expect(HauntedHouse.find_by(name: "Asylum Haunted House")).to eq(asylum)
  end

  it "has a location" do
    address = "18301 W Colfax Ave, Golden, CO 80401"
    spider_mansion = HauntedHouse.create(
      name: "Spider Mansion",
      location: address
    )
    expect(HauntedHouse.find_by(location: address)).to eq(spider_mansion)
  end

  it "has a theme" do
    undead = HauntedHouse.create(
      name: "Undead: The Possession",
      theme: "zombies"
    )
    expect(HauntedHouse.find_by(theme: "zombies")).to eq(undead)
  end

  it "has a price" do
    primative_fear = HauntedHouse.create(
      name: "Primative Fear",
      price: 25.00
    )
    expect(HauntedHouse.find_by(price: 25.00)).to eq(primative_fear)
  end

  it "knows if it's family friendly" do
    {"Fright Fest"=>true, "13th Street Manor"=>false}.each do |name, boolean|
      HauntedHouse.create(name: name, family_friendly: boolean)
    end
    expect(HauntedHouse.find_by(name: "Fright Fest").family_friendly).to eq(true)
    expect(HauntedHouse.find_by(name: "13th Street Manor").family_friendly).to eq(false)
  end

  it "has an opening date" do
    sept_27th = Date.new(2014,9,27)
    mckamey = HauntedHouse.create(name: "McKamey Manor", opening_date: sept_27th)
    expect(HauntedHouse.find_by(opening_date: sept_27th)).to eq(mckamey)
  end

  it "has a closing date" do
    nov_2nd = Date.new(2014,11,02)
    esp = HauntedHouse.create(name: "Eastern State Penitentiary", closing_date: nov_2nd)
    expect(HauntedHouse.find_by(closing_date: nov_2nd)).to eq(esp)
  end

  it "has a long, long description" do
    description = get_description
    HauntedHouse.create(name: "13th Floor", description: description)
    expect(HauntedHouse.find_by(name: "13th Floor").description).to eq(description)
  end

end