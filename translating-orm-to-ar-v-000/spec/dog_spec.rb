require "spec_helper"
require "pry"

describe "Dog" do

  let(:teddy) {Dog.new(name: "Teddy", breed: "cockapoo")}

  before do
    DB.execute("DROP TABLE IF EXISTS dogs")
    @sql_runner = SQLRunner.new(DB)
    @sql_runner.execute_schema_migration_sql
  end

  describe "inheritence" do
    it 'inherits from ActiveRecord::Base' do
      expect(Dog.superclass).to eq(ActiveRecord::Base)
    end
  end

  describe "attributes" do
    it 'has a name and a breed' do
      dog = Dog.new({name: "Fido", breed: "lab"})
      expect(dog.name).to eq("Fido")
      expect(dog.breed).to eq("lab")
    end
  end

  describe '.create' do
    it 'takes in a hash of attributes and uses metaprogramming to create a new dog object. Then it uses the #save method to save that dog to the database' do
      dog = Dog.create(name: "Ralph", breed: "lab")
      expect(dog.name).to eq("Ralph")
    end
  end

  describe '.save' do
    it 'saves an instance of the dog class to the database and then sets the given dogs `id` attribute' do
      dog = Dog.new({name: "Fido", breed: "lab"})
      dog.save
      expect(dog.id).to eq(1)
    end
  end

  describe '.update' do
    it 'updates the record associated with a given instance' do
      teddy.save
      teddy.update({name: "Teddy Jr."})
      teddy_jr = Dog.find_by_name("Teddy Jr.")
      expect(teddy_jr.id).to eq(teddy.id)
    end
  end

  describe '.find_or_create_by' do
    it 'creates a dog if it does not already exist' do
      dog1 = Dog.create(name: 'Teddy', breed: 'cockapoo')
      dog2 = Dog.find_or_create_by(name: 'Teddy', breed: 'cockapoo')
      expect(dog1.id).to eq(dog2.id)
    end
  end

  describe '.find_by_name' do
    it 'returns a dog that matches the name from the DB' do
      teddy.save
      teddy_from_db = Dog.find_by_name("Teddy")
      expect(teddy_from_db.name).to eq("Teddy")
      expect(teddy_from_db).to be_an_instance_of(Dog)
    end
  end

  describe '.find_by_id' do
    it 'returns a dog that matches the name from the DB' do
      teddy.save
      teddy_from_db = Dog.find_by_id(1)
      expect(teddy_from_db.id).to eq(1)
      expect(teddy_from_db).to be_an_instance_of(Dog)
    end
  end

end
