require_relative './spec_helper'
describe "an ok request" do
  it 'wins if they are all the same' do
    allow(Kernel).to receive(:rand).and_return(2)
    get '/'
    expect(last_response.body).to include("You Win")
  end

  it 'loses if they are different' do
    numbers = [1,2,3]
    index = 0
    allow(Kernel).to receive(:rand){
      numbers[index]
      index+=1
    }

    get '/'
    expect(last_response.body).to include("You Lose")
  end
end
