require 'spec_helper'
require 'rake'


describe "Rakefile" do 
  before(:all) do 
    load File.expand_path("../../Rakefile", __FILE__)
  end

  describe 'namespace :greeting' do
    describe 'greeting:hello' do

      it "should print out 'hello from Rake!'" do
        expect($stdout).to receive(:puts).with("hello from Rake!")
        Rake::Task["greeting:hello"].invoke
      end


    end

    describe 'greeting:hola' do

      it "should print out 'hola de Rake!'" do
        expect($stdout).to receive(:puts).with("hola de Rake!")
        Rake::Task["greeting:hola"].invoke
      end
    end
  end

  describe 'namespace :db' do

    describe 'db:migrate' do 
      it "invokes the :environment task as a dependency" do
        expect(Rake::Task["db:migrate"].prerequisites).to include("environment")
      end

      it "create the students table in the database" do
        Rake::Task["db:migrate"].invoke
        sql = "SELECT name FROM sqlite_master WHERE type='table'ORDER BY name;"
        expect(DB[:conn].execute(sql).first).to include("students")
      end
    end

    describe 'db:seed' do

      before(:each) do
        clear_database
        recreate_table
      end 

      it "seeds the database with dummy data from a seed file" do
        Rake::Task["db:seed"].invoke
        sql = "select * from students;"
        dummy_data = DB[:conn].execute(sql)
        expect(dummy_data.length).to eq(5)
        expect(dummy_data.first[0]).to eq(1)
        expect(dummy_data[1][1]).to eq("April")
        expect(dummy_data[4][2]).to eq("10th")
      end


    end

  end


end