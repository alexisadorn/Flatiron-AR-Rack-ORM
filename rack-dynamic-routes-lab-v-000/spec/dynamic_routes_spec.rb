require_relative './spec_helper'

describe "Shopping Cart Rack App" do
  def app()
    Application.new
  end

  it 'Returns 404 for a bad route' do
    get '/testing'
    expect(last_response.body).to include("Route not found")
    expect(last_response.status).to be(404)
  end
  describe "/items" do

    it 'Returns item price if it is in @@item' do
      Application.class_variable_set(:@@items, [Item.new("Figs",3.42),Item.new("Pears",0.99)])
      get '/items/Figs'
      expect(last_response.body).to include("3.42")
      expect(last_response.status).to be(200)
    end

    it 'Returns an error and 400 if the item is not there' do
      Application.class_variable_set(:@@items, [Item.new("Figs",3.42),Item.new("Pears",0.99)])
      get '/items/Apples'
      expect(last_response.body).to include("Item not found")
      expect(last_response.status).to be(400)
    end

  end
end
