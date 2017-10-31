require_relative 'spec_helper'

describe "Costume" do

  it "has a name" do
    hot_dog = Costume.create(
      name: "Unisex Adult Hot Dog Costume"
    )
    expect(Costume.find_by(name: "Unisex Adult Hot Dog Costume")).to eq(hot_dog)
  end

  it "has a price" do
    pirate = Costume.create(
      name: "Men's Grand Heritage Caribbean Pirate",
      price: 169.97
    )
    expect(Costume.find_by(price: 169.97)).to eq(pirate)
  end

  it "has an image url" do
    url = "http://img.costumecraze.com/images/vendors/rasta/7139-large.jpg"
    penguin = Costume.create(
      name: "Happy Penguin",
      image_url: url
    )
    expect(Costume.find_by(image_url: url)).to eq(penguin)
  end

  it "has a size" do
    horse = Costume.create(
      name: "Horse Mask",
      image_url: "http://a.tgcdn.net/images/products/zoom/ec82_horse_head_mask.jpg",
      size: "medium"
    )
    expect(Costume.find_by(size: "medium")).to eq(horse)
  end

  it "knows when it was created" do
    bee = Costume.create(name: "Dog's Bumble Bee", image_url: "http://cdn.sheknows.com/filter/l/gallery/halloween_costume_dog_bumblebee.jpg",size: "medium")
    expect { bee.created_at }.to_not raise_error
    expect(bee.created_at.to_datetime === Time.now.utc.to_datetime).to eq(true)
  end

  it "knows when it was last updated" do
    stegosaurus = Costume.create(name: "Stegosaurus Tortoise Cozy", image_url: "https://img1.etsystatic.com/036/1/7507736/il_570xN.513886615_45eg.jpg")
    stegosaurus.update(:size => "large")
    expect { stegosaurus.updated_at }.to_not raise_error
    expect(stegosaurus.updated_at.to_datetime ===  Time.now.utc.to_datetime).to eq(true)
    expect(stegosaurus.updated_at.to_datetime).to be > stegosaurus.created_at.to_datetime
  end

end