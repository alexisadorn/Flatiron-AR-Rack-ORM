# ORM Mapping Classes to Tables Lab

## Objectives

1. Write a class that is mapped, or equated, to a database table. 
2. Build a method that creates a table that maps to the given class. 
3. Write a method that drops that table. 
4. Write a method that saves a given instance to the database table. 
5. Write a method that both creates a new instance of the class *and* saves that instance to a database table. 

## Overview

Let's say we're building an app to help a public school's administrators keep track of their students. In this app we have a `Student` class. Each individual student will have two attributes, a `name` and a `grade`, i.e. 9th, 10th, 11th, etc. 

Our administrators need to save the student objects that this class produces to a database. We've set up the database for you in the `config/environment.rb` file. 

Let's take a look:

```ruby
require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}
```
Your connection to the database can be referred to, throughout your program, like this: `DB[:conn]`. 

Your job is to build out the `Student` class such that it has the two attributes described above. You'll also need to build a class method on the `Student` class that creates the students table in the database, a method that can drop that table and a method, `#save`, that can save the data concerning an individual student object to the database. 

Lastly, you'll create a method that *both creates a new instance of the student class and then saves it to the database.*

Let's get started!

## Instructions

### Attributes

Your `Student` instances should initialize with a name, grade and an optional id. The default value of the `id` argument should be set to `nil`. This is because when we create new `Student` instances, we will not assign them an `id`. That is the responsibility of the database and we will learn more about that later. 

`Student` attributes should have an `attr_accessor` for `name` and `grade` but only an `attr_reader` for `id`. The only place `id` can be set equal to something is inside the initialize method, via: `@id = some_id`

### The `.create_table` Method

This is a class method that creates the students table. Use a heredoc to set a variable, `sql`, equal to the necessary SQL statement. Remember, the attributes of a student, `name`, `grade`, and `id`, should correspond to the column names you are creating in your students table. The `id` column should be the primary key. 

With your `sql` variable pointing to the correct SQL statement, you can execute that statement using the `#execute` method provided to use by the SQLite3-Ruby gem. Remember that this method is called on whatever object stores your connection to the database, in this case `DB[:conn]`.

### The `.drop_table` Method

This is a class method that drops the students table. Once again, create a variable `sql`, and set it equal to the SQL statement that drops the students table. Execute that statement againt the database using `DB[:conn].execute(sql)`. 

### The `#save` Method

This is an instance method that saves the attributes describing a given student to the students table in our database. Once again, create a variable, `sql`, and set it equal to the SQL statement that will `INSERT` the correct data into the table. 

Use bound paremeters to pass the given student's name and grade into the SQL statement. Remember that you don't need to insert a value for the `id` column. Because it is the primary key, the `id` column's value will be automatically assigned. **However**, at the end of your `#save` method, you do need to grab the ID of the last inserted row, i.e. the row you just inserted into the database, and assign it to the be the value of the @id attribute of the given instance.

### The `.create` Method

This is a class method that uses keyword arguments. The keyword arguments are `name:` and `grade:`. Use the values of these keyword arguments to: 1) instantiate a new `Student` object with `Student.new(name, grade)` and 2) save that new student object via `student.save`. The `#create` method should return the student object that it creates. 


<a href='https://learn.co/lessons/orm-mapping-to-table-lab' data-visibility='hidden'>View this lesson on Learn.co</a>

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/orm-mapping-to-table-lab'>Mapping Classes to Tables Lab</a> on Learn.co and start learning to code for free.</p>
