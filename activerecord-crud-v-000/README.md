# Active Record CRUD

## Objective
The goal of this lab is to get comfortable performing CRUD (Create, Read, Update, Delete) actions using Active Record.

There are different ways to solve this lab so feel free to experiment!

##Instructions
Before starting this lab run `bundle`, to get the proper gem dependencies. If your operating system is OSX El Capitan, and you have an issue installing `EventMachine`, first check to make sure Open SSL is installed by entering `brew install openssl` in terminal. Once it's installed, enter `brew link openssl --force`.

Also enter `rake -T`, which will list all of the rake tasks you have available in this lab. These tasks come with the `sinatra-activerecord` gem.

Start the lab by running `learn` or keep reading for more instructions.

###Create Table
Try using the rake task `rake db:create_migration NAME=create_movies` to create your migration file.
Once you have a migration file add columns for title ,release_date, director, lead, and in_theaters.
After your migration is ready run `rake db:migrate` to migrate your table and `rake db:migrate SINATRA_ENV=test` to migrate a test database so you will be able to run `learn`

###Tests
Run `rspec` or `learn` to see the tests. To make them pass open `movie_controller.rb` and complete each method. It will help to open `spec/models/movie_spec.rb` to see exactly what each spec is testing for.

In each method the `__` corresponds to a line of code you will need to write to make the spec pass. 

Each test will take us through performing a basic CRUD action using the database we just created. These tests will take you through:

####Create
* A movie can be instantiated, given a title, and saved
* A movie can be instantiated with a hash containing all of its attributes
* A movie can be created in a block

####Read
* You can return the first item in the database
* You can return the last item in the database
* You can return the title of all the items in database and get their length
* You can return a movie from the database based on its attributes
* You can use a `where` clause to select the appropriate movies and sort them by release date

####Update
* Can be found, updated, and saved
* Can be updated using the `update` method
* Can update all records at once

####Destroy
* Can destroy a single item
* Can destroy all items at once


##Resources
[Active Record Query Interface](http://guides.rubyonrails.org/active_record_querying.html).

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/activerecord-crud' title='Active Record CRUD'>Active Record CRUD</a> on Learn.co and start learning to code for free.</p>
