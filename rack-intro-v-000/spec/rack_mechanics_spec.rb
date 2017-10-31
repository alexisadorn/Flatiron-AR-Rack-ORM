require 'spec_helper.rb'

describe "Application" do
  it "should introduce itself" do
    get "/"
    expect(last_response.body).to include ("Hello, my name is")
  end
end
