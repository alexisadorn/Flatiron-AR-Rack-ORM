require_relative 'spec_helper'

describe Show do
  let(:show) {Show.new}

  it "has data attributes" do
    #TODO: You'll need to create a new migration to add
    #the necessary columns to the shows table
    community = Show.create(:name => "Community", :day => "Thursday", :season => "Winter")
    expect(community.day).to eq("Thursday")
    expect(community.season).to eq("Winter")
  end

  it "has many characters in an array" do
    #TODO: we need to associate characters to shows. for reference
    #look how shows are associated with networks
    #pay attention to both the model and the migrations
    show.name = "The Simpsons"
    characters = [
      Character.new(:name => "Ralph Wiggum"),
      Character.new(:name => "Homer Simpson"),
      Character.new(:name => "Apu Nahasapeemapetilon")
    ]
    # We can assign many characters to a show through the characters array with a push
    show.characters << characters
    show.save
    expect(show.characters.count).to eq(3)
    expect(show.characters.collect { |s| s.name }).to include("Homer Simpson")
  end

  it "can build its characters through a method" do
    show.name = "Happy Endings"
    # we can access the characters collection and call build there to build one
    show.characters.build(:name => "Penny")
    show.save
    expect(show.characters.count).to eq(1)
  end

  it "should have a genre" do
    #TODO: you'll need to add yet another new field to shows here
    show.name = "Gilmore Girls"
    show.genre = "Dramedy"
    show.save
    dramedy = Show.find_by(:genre => "Dramedy")
    expect(dramedy.name).to eq("Gilmore Girls")
  end

   it "can build an associated network" do
    # to do this, the show model has to define its relationship with network
    show.build_network(:call_letters => "NBC")
    expect(show.network.call_letters).to eq("NBC")
  end
end