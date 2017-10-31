# TV Land ActiveRecord Associations Lab

## Objectives

1. Create and modify tables using ActiveRecord migrations.
2. Build associations between models using Active Record macros.

## Overview

In this lab, we'll be working with a TV show domain model. We will have a show, network and character model. They will be associated in the following way:

* An actor has many characters and has many shows through characters. 
* A character belongs to an actor and belongs to a show. 
* A show has many characters and has many actors through characters. 

We've given you a few migrations in the `db/migrate` directory to create the networks and shows table, but you'll have to add additional tables and modify these existing tables as per the guidelines below. 

**Remember to run `rake db:migrate` in the terminal before you run your tests and after you make any new migrations!**

## Instructions

### `spec/actor_spec.rb` and `spec/character_spec.rb`

* Write a migration for the actors table. An actor should have a `first_name` and a `last_name`. 
* Write a migration for the characters table. A character should have a `name` and a `show_id`––a character will belong to a show. 
* Associate the `Actor` model with the `Character` and `Show` model. An actor should have many characters and many shows through characters. 
* Write a method in the `Actor` class, `#full_name`, that returns the first and last name of an actor. 
* Write a method in the `Actor` class, `#list_roles`, that lists all of the characters that actor has. 
* Write a migration that adds the column `catchphrase` to your character model.
* Define a method in the `Character` class, `#say_that_thing_you_say`, using a given character's catchphrase.

### `spec/show_spec.rb`
 
* Write a migration for the shows table. A show should have a name and a genre. 
* Create the neccesary associations between shows, networks, and characters. 


## Resources
* Rails Guide - [Active Record Associations](http://guides.rubyonrails.org/association_basics.html)
* Api dock - [Active Record Associations](http://apidock.com/rails/ActiveRecord/Associations)
* Rails Guide - [Active Record Migrations](http://edgeguides.rubyonrails.org/active_record_migrations.html)

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/activerecord-tvland' title='TV Land ActiveRecord Associations Lab'>TV Land ActiveRecord Associations Lab</a> on Learn.co and start learning to code for free.</p>
