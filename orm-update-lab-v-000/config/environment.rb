require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}