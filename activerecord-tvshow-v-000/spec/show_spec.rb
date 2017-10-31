require_relative 'spec_helper'

describe Show do

  after(:each) do
    Show.destroy_all
  end

  before(:each) do
    @rick_and_morty = Show.create(:name => "Rick and Morty", :day => "Thursday", :network => "Adult Swim", :rating => 10)
    @law_and_order = Show.create(:name => "Law & Order", :day => "Monday", :network => "NBC", :rating => 7)
    @the_cleveland_show = Show.create(:name => "The Cleveland Show", :day => "Monday", :network => "Fox", :rating => 2)
    @fear_the_walking_dead = Show.create(:name => "Fear the Walking Dead", :day => "Sunday", :network => "AMC", :rating => 3)
  end

  describe "attributes" do
    it "has data attributes given to it from a migration file" do
    #TODO: You'll need to create a new migration to add
    #the necessary columns to the shows table
      expect(@rick_and_morty.name).to eq("Rick and Morty")
      expect(@rick_and_morty.day).to eq("Thursday")
      expect(@rick_and_morty.network).to eq("Adult Swim")
      expect(@rick_and_morty.rating).to eq(10)
    end

    it "has a season" do
      game_of_thrones = Show.create(:name => "Game of Thrones", :day => "Sunday", :season => "Spring", :network => "HBO", :rating => 10)
      expect(game_of_thrones.season).to eq("Spring")
    end

    it "has a season column and attribute added from another migration file" do
      filepath = File.expand_path(File.dirname(File.dirname(__FILE__))) + "/db/migrate"
      expect(Dir.entries(filepath)).to include("002_add_season_to_shows.rb")
    end
  end

  describe "::highest_rating" do
    it "returns the TV show with the highest rating" do
      expect(Show.highest_rating).to eq(10)
    end
  end

  describe "::most_popular_show" do
    it "returns the tv show with the highest rating" do
      expect(Show.most_popular_show).to eq(@rick_and_morty)
    end
  end

  describe "::lowest_rating" do
    it "returns the TV show with the lowest rating" do
      expect(Show.lowest_rating).to eq(2)
    end
  end

  describe "::least_popular_show" do
    it "returns the tv show with the lowest rating" do
      expect(Show.least_popular_show).to eq(@the_cleveland_show)
    end
  end

  describe "::ratings_sum" do
    it "returns the sum of all the ratings of all the tv shows" do
      expect(Show.ratings_sum).to eq(22)
    end
  end

  describe "::popular_shows" do
    it "returns an array of all of the shows with a rating above 5" do
      expect(Show.popular_shows).to eq([@rick_and_morty, @law_and_order])
    end
  end

  describe "::shows_by_alphabetical_order" do
    it "returns an array of all of the shows, listed in alphabetical order" do
      expect(Show.shows_by_alphabetical_order).to eq([@fear_the_walking_dead, @law_and_order, @rick_and_morty, @the_cleveland_show])
    end
  end
end
