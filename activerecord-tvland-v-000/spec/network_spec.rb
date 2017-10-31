require_relative 'spec_helper'

describe Network do
  let(:network) { Network.new }

  it "has data attributes" do
    nbc = Network.create(:channel => 4, :call_letters => "NBC")
    expect(nbc.channel).to eq(4)
    expect(nbc.call_letters).to eq("NBC")
  end

  it "has many shows" do
    network.call_letters = "NBC"
    network.shows << Show.new(:name => "Community")
    network.save
    expect(network.shows.count).to eq(1)
  end

  it "can build an associated show" do
    network.shows.build { Show.new(:name => "Community") }
    network.save
    expect(network.shows.count).to eq(1)
  end

  it "should have picked up John Mulaney's Pilot" do
    network.call_letters == "NBC"
    expect(network.sorry).to eq("We're sorry about passing on John Mulaney's pilot")
  end
end
