require_relative '../spec_helper'
describe 'Song' do
  before do
    @song = Song.create(name: "Forever")
  end

  it 'has a name' do
    expect(Song.where(name: "Forever").first).to eq(@song)
  end

end
