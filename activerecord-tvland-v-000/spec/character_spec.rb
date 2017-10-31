require_relative 'spec_helper'

describe Character do

  it "belongs to an actor" do
    danny_pudi = Actor.create(first_name: "Danny", last_name: "Pudi")
    abed = Character.create(name:'Abed', actor_id: danny_pudi.id)
    expect(Character.find_by(:name => "Abed").actor).to eq(danny_pudi)
  end

  it "belongs to a show" do
    frasier = Show.new(:name => "Frasier")
    niles = Character.new(:name => "Niles Crane")
    niles.show = frasier
    niles.save
    
    frasier.reload
    expect(frasier.characters).to include(niles)
    expect(niles.show).to eq(frasier)
  end

  it "has a catchphrase" do
    #TODO: make a method in the model to say his name and catchphrase
    #remember the model is yours do with as you please, you 
    #are free to add methods that perform actions on the model's data

    urkel = Character.new(:name => "Steve Urkel")
    urkel.catchphrase = "Did I do that?"
    urkel.save
    expect(Character.find_by(:id => urkel.id).catchphrase).to eq(urkel.catchphrase)

    expect(urkel.say_that_thing_you_say).to eq("#{urkel.name} always says: #{urkel.catchphrase}")

  end

  it "can build its associated show" do
    jules_cobb = Character.new(:name => "Jules Cobb")
    jules_cobb.build_show(:name => "Cougar Town")
    expect(jules_cobb.show.name).to eq("Cougar Town")
  end

  it "can chain-build associations to which it belongs" do
    malcolm = Character.new(:name => "Malcolm Reynolds")
    # We can use the build_xxx method all the way up a chain, 
    # because each one returns an instance of that type of object
    malcolm.build_show(:name => "Firefly").build_network(:call_letters => "Fox")
    show = malcolm.show
    expect(show.name).to eq("Firefly")
    expect(show.network.call_letters).to eq("Fox")
  end

end
