require_relative 'spec_helper'

describe "Actor" do
  let(:actor) {Actor.new}
  #TODO: implement the tests as described in the it blocks,
  #      and implement the class and migrations required to pass them

  # HINTS: look at show_spec.rb and network_spec.rb and character_spec.rb for guidance

  it "has a first and last name" do
    # TODO set up the basic data model for actor
    actor = Actor.create(:first_name => "Emilia", :last_name => "Clarke")

    expect(actor.first_name).to eq("Emilia")
    expect(actor.last_name).to eq("Clarke")
  end

  it "has associated characters in an array" do
    # Hint: think about what migration you'll need to write so that an actor can have many characters.
    # Where will the association foreign key go?
    emilia = Actor.new(:first_name => "Emilia", :last_name => "Clarke")
    khaleesi = Character.new(:name => "Khaleesi")
    khaleesi.actor = emilia
    khaleesi.save

    khaleesi.reload
    expect(emilia.characters).to include(khaleesi)
    expect(khaleesi.actor).to eq(emilia)
  end

  it "can build its associated characters" do
    emilia = Actor.new(:first_name => "Emilia", :last_name => "Clarke")
    khaleesi = Character.new(:name => "Khaleesi")
    khaleesi.actor = emilia
    khaleesi.save

    khaleesi.reload
    expect(emilia.characters.first.name).to eq("Khaleesi")
  end

  it "can build its associated shows through its characters" do
    emilia = Actor.new(:first_name => "Emilia", :last_name => "Clarke")
    khaleesi = Character.new(:name => "Khaleesi")
    khaleesi.actor = emilia
    got = Show.new(:name => "Game of Thrones")
    khaleesi.show = got
    khaleesi.save

    khaleesi.reload
    expect(khaleesi.show.name).to eq("Game of Thrones")
  end

  it "can list its full name" do
    # TODO create an instance method on actor called full_name to return first and
    #last name together
    emilia = Actor.new(:first_name => "Emilia", :last_name => "Clarke")
    emilia.save

    emilia.reload
    expect(emilia.full_name).to eq("Emilia Clarke")
  end

  it "can list all of its shows and characters" do
    # TODO create a list_roles method
    # TODO: build a method on actor that will return an array of
    # strings in the form "#{character_name} - #{show_name}"
    emilia = Actor.new(:first_name => "Emilia", :last_name => "Clarke")
    khaleesi = Character.new(:name => "Khaleesi")
    khaleesi.actor = emilia
    got = Show.new(:name => "Game of Thrones")
    khaleesi.show = got
    khaleesi.save

    khaleesi.reload
    expect(emilia.list_roles).to include("Khaleesi - Game of Thrones")
  end
end
