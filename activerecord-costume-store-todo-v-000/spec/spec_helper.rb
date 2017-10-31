ENV["ACTIVE_RECORD_ENV"] = "test"

require_relative '../config/environment'

RSpec.configure do |config|

  config.before(:suite) do
    clear_db
    system("rake db:migrate")
    DB.tables
  end

end

def __
  raise "Replace __ with test code."
end

def clear_db
  File.open("db/halloween-test.db", "w+") {|f| f.puts ""}
end

def get_opening_time
  d = Date.today
  Time.new(d.year, d.month, d.day, 9, 00)
end

def get_closing_time
  d = Date.today
  Time.new(d.year, d.month, d.day, 22, 00)
end

def get_description
  description = <<-eos
    DENVER’S #1 RATED HAUNTED HOUSE! FEATURED ON THE TRAVEL CHANNEL'S SHOW AMERICA'S SCARIEST HALLOWEEN ATTRACTIONS!
    CHANGES, UPDATES, AND ENHANCEMENTS GALORE, ALL NEW FOR THE 2014 SEASON!
    RATED IN THE TOP 10 HAUNTED HOUSES IN AMERICA BY HAUNTWORLD MAGAZINE!
    "A mixture of visceral thrills and psychological horror!"
    Are you ready to GET SCARED?! FACE YOUR FEAR at the most insane haunted houses of all Denver Haunted Houses!
    “Within the walls of the legendary Nightmare Factory a hidden passage was unearthed!
    This passage descended two levels into Gordon Cottingham's Hospital for the Mentally Insane, The Asylum.
    Much deeper and darker than the previous levels, the Asylum is a damp and musty place infested with spiders, rats, snakes, and the endless screams of the tortured souls.”
    From the creators of the 13th Floor Haunted House and Nightmare Factory, The Asylum Haunted House is the scariest haunted adventure in all of Denver, Colorado!
    Featuring all new up-close and in-your- face frights for 2014!
  eos
end
