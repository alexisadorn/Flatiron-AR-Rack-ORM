require 'sqlite3'

require_relative "../lib/song.rb"
require_relative "../config/environment.rb"


song = Song.new(name: "Hello", album: "25")
puts "song name: " + song.name
puts "song album: " + song.album
song.save

DB[:conn].execute("SELECT * FROM songs")
