require 'sqlite3'

require_relative "../lib/interactive_record.rb"
require_relative "../lib/song.rb"
require_relative "../config/environment.rb"

song = Song.new(name: "Hello", album: "25")
puts "song name: " + song.name
puts "song album: " + song.album
song.save

puts Song.find_by_name("Hello")

# DB[:conn].execute("SELECT * FROM songs")
