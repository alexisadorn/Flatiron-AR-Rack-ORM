ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
require 'rack/test'
require 'rake'


RSpec.configure do |config|

  config.color = true

  config.order = 'default'
end

def clear_database
  sql = "DROP TABLE IF EXISTS students"
  DB[:conn].execute(sql) 
end

def recreate_table
  sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql) 
end