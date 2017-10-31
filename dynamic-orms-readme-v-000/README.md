# Dynamic ORMs

## Objectives

1. Explain why a dynamic ORM is useful to us as developers
2. Build a basic dynamic ORM
3. Build a dynamic ORM that can be used by any given Ruby class

## Why Dynamic ORMs?

As developers, we understand the need for our Ruby programs to be able to connect with a database. Any complex application is going to need to persist some data. Along with this need, we recognize the need for the connection between our program and our database to be, like all of our code, organized and sensible. That is why we use the ORM design pattern in which a Ruby class is mapped to a database table and instances of that class are represented as rows in that table.

We can implement this mapping by using a class to create a database table:

```ruby
class Song
  attr_accessor :name, :album
  attr_reader :id

  def initialize(id=nil, name, album)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end
end
```

Here, we create our `songs` table, so-named because we are mapping this table to an existing class, `Song`. The column names for the table are taken from the known `attr_accessor`s of the `Song` class.

This is one way to map our program to our database, but it has some limitations. For one thing, our `#create_table` method is dependent on our knowing exactly what to name our table and columns. So, every class in our program would require us to re-write this `#create_table` method, swapping out different table and column names each time. This is repetitive. As you know, we programmers are lazy and we hate to repeat ourselves. Any smelly, repetitious code, begs the question: can we abstract this into a re-usable method? In this case––can we extract our class-specific `#create_table` method into one that is flexible and abstract and be used across any class?

Well, with a dynamic ORM, we can abstract all of our conventional ORM methods into just such flexible, abstract, and shareable methods.

## What is a Dynamic ORM?

A dynamic ORM allows us to map an existing database table to a class and write methods that can use nothing more than information regarding a specific database table to:

* Create `attr_accessors` for a Ruby class.
* Create shareable methods for inserting, updating, selecting, and deleting data from the database table.

This pattern –– first creating the database table and having your program do all the work of writing your ORM methods for you, based on that table –– is exactly how we will develop web applications in Sinatra and Rails.

## Creating Our ORM

**Important:** Writing an ORM is hard! It will require a lot of abstract thinking and we will be doing some metaprogramming. That's why we've provided you all of the code we'll be looking at in this walk-through. You'll find the code in `lib/song.rb`. You should clone down this repo and play around with the code to get more familiar with it.

## Step 1: Setting Up the Database

For this exercise, we'll be working with a `Song` class. To create a dynamic ORM, we start by creating our database and songs table. In `config/environment.rb` you'll find the following code:

```ruby
require 'sqlite3'


DB = {:conn => SQLite3::Database.new("db/songs.db")}
DB[:conn].execute("DROP TABLE IF EXISTS songs")

sql = <<-SQL
  CREATE TABLE IF NOT EXISTS songs (
  id INTEGER PRIMARY KEY,
  name TEXT,
  album TEXT
  )
SQL

DB[:conn].execute(sql)
DB[:conn].results_as_hash = true
```

Here we are doing a couple of things:

1. Creating the database.
2. Drop `songs` to avoid an error.
3. Creating the `songs` table.

Lastly, we use the `#results_as_hash` method, available to use from the SQLite3-Ruby gem. This method says: when a `SELECT` statement is executed, don't return a database row as an array, return it as a hash with the column names as keys.

So, instead of `DB[:conn].execute("SELECT * FROM songs LIMIT 1")` returning something that looks like this:

```ruby
[[1, "Hello", "25"]]
```

It will return something that looks like this:

```ruby
{"id"=>1, "name"=>"Hello", "album"=>"25", 0 => 1, 1 => "Hello", 2 => "25"}
```

This will be helpful to us as we use information requested from our database table to build attributes and methods on our `Song` class, but more on that later.

Okay, now that we see how our database and table have been set up, let's move onto metaprogramming our `Song` class using information from our database.

## Step 2: Building `attr_accessor`s from column names

The next step of building our dynamic ORM is to use the column names of the `songs` table to dynamically create the `attr_accessor`s of our `Song` class. In order to do that, we first need to collect the column names from our `songs` table. In order to collect the column names from the songs table we need to tell our `Song` class what table to query. However, we *don't* want to tell the `Song` class to query the `songs` table explicitly. This would not be flexible. If we defined a method that explicitly referenced the `songs` table, we would not be able to extract that method into a *shareable* method later on. Remember, the goal of our dynamic ORM is to define a series of methods that can be shared by *any class*. So, we need to avoid explicitly referencing table and column names.

Now that we understand what we need to do, let's write a method that returns the name of a table, given the name of a class:

### The `#table_name` Method

```ruby
class Song
  def self.table_name
    self.to_s.downcase.pluralize
  end
end
```

This method, which you'll see in the `Song` class in `lib/song.rb`, takes the name of the class, referenced by the `self` keyword, turns it into a string with `#to_s`, downcases (or "un-capitalizes") that string and then "pluralizes" it, or makes it plural.

**Note:** The `#pluralize` method is provided to us by the `active_support/inflector` code library, required at the top of `lib/song.rb`.

Now that we have a method that grabs us the table name we want to query for column names, let's build a method that actually grabs us those column names.

### The `#column_names` Method

**Querying a table for column names:**

How do you query a table for the names of its columns? For this we need to use the following SQL query:

```sql
PRAGMA table_info(<table name>)
```

This will return to us (thanks to our handy `#results_as_hash` method) an array of hashes describing the table itself. Each hash will contain information about one column. The array of hashes will look something like this:

```ruby
 [{"cid"=>0,
  "name"=>"id",
  "type"=>"INTEGER",
  "notnull"=>0,
  "dflt_value"=>nil,
  "pk"=>1,
  0=>0,
  1=>"id",
  2=>"INTEGER",
  3=>0,
  4=>nil,
  5=>1},
 {"cid"=>1,
  "name"=>"name",
  "type"=>"TEXT",
  "notnull"=>0,
  "dflt_value"=>nil,
  "pk"=>0,
  0=>1,
  1=>"name",
  2=>"TEXT",
  3=>0,
  4=>nil,
  5=>0},
 {"cid"=>2,
  "name"=>"album",
  "type"=>"TEXT",
  "notnull"=>0,
  "dflt_value"=>nil,
  "pk"=>0,
  0=>2,
  1=>"album",
  2=>"TEXT",
  3=>0,
  4=>nil,
  5=>0}]
```

That's a lot of information! The only thing we need to grab out of this hash is the name of each column. Each hash has a `"name"` key that points to a value of the column name.

Now that we know how to get information about each column from our table, let's write our `#column_names` method:

**Building our method:**

```ruby
def self.column_names
  DB[:conn].results_as_hash = true

  sql = "PRAGMA table_info('#{table_name}')"

  table_info = DB[:conn].execute(sql)
  column_names = []

  table_info.each do |column|
    column_names << column["name"]
  end

  column_names.compact
end
```

Here we write a SQL statement using the `pragma` keyword and the `#table_name` method (to access the name of the table we are querying). We iterate over the resulting array of hashes to collect *just the name of each column*. We call `#compact` on that just to be safe and get rid of any `nil` values that may end up in our collection.

The return value of calling `Song.column_names` will therefore be:

```ruby
["id", "name", "album"]
```

Now that we have a method that returns us an array of column names, we can use this collection to create the `attr_accessors` of our `Song` class.

### Metaprogramming our `attr_accessor`s

We can tell our `Song` class that it should have an `attr_accessor` named after each column name with the following code:

```ruby
class Song
  def self.table_name
    #table_name code
  end

  def self.column_names
    #column_names code
  end

  self.column_names.each do |col_name|
    attr_accessor col_name.to_sym
  end
end
```

Here, we iterate over the column names stored in the `column_names` class method and set an `attr_accessor` for each one, making sure to convert the column name string into a symbol with the `#to_sym` method, since `attr_accessor`s must be named with symbols.

This is metaprogramming because we are writing code that writes code for us. By setting the `attr_accessor`s in this way, a reader and writer method for each column name is dynamically created, without us ever having to explicitly name each of these methods.

## Step 3: Building an abstract `#initialize` Method

Now that our `attr_accessor`s are defined, we can build the `#initialize` method for the `Song` class. Just like everything else about our dynamic ORM, we want our `#initialize` method to be abstract, i.e. not specific to the `Song` class, so that we can later remove it into a parent class that any other class can inherit from. Once again, we'll use metaprogramming to achieve this.

We want to be able to create a new song like this:

```ruby
song = Song.new(name: "Hello", album: "25")

song.name
# => "Hello"

song.album
# => "25"
```

So, we need to define our `#initialize` method to take in a hash of named, or keyword, arguments. However, we *don't* want to explicitly name those arguments. Here's how we can do it:

### The `#initialize` Method

```ruby
def initialize(options={})
  options.each do |property, value|
    self.send("#{property}=", value)
  end
end
```

Here, we define our method to take in an argument of `options`, which defaults to an empty hash. We expect `#new` to be called with a hash, so when we refer to `options` inside the `#initialize` method, we expect to be operating on a hash.

We iterate over the `options` hash and use our fancy metaprogramming `#send` method to interpolate the name of each hash key as a method that we set equal to that key's value. As long as each `property` has a corresponding `attr_accessor`, this `#initialize` method will work.

## Step 4: Writing our ORM Methods

Let's move on to writing some of the conventional ORM methods, like `#save` and `#find_by_name`, in a dynamic fashion. In other words, we will write these methods to be abstract, not specific to the `Song` class, so that we can later extract them and share them among any number of classes.

### Saving Records in a Dynamic Manner

Let's take a look at the basic SQL statement required to save a given song record:

```sql
INSERT INTO songs (name, album)
VALUES 'Hello', '25';
```

In order to write a method that can `INSERT` any record to any table, we need to be able to craft the above SQL statement without explicitly referencing the `songs` table or column names and without explicitly referencing the values of a given `Song` instance.

Let's take this one step at a time.

#### Abstracting the Table Name

Luckily for us, we already have a method to give us the table name associated to any given class: `<class name>.table_name`.

Recall, however, that the conventional `#save` is an *instance* method. So, inside a `#save` method, `self` will refer to the instance of the class, not the class itself. In order to use a class method inside an instance method, we need to do the following:

```ruby
def some_instance_method
  self.class.some_class_method
end
```

So, to access the table name we want to `INSERT` into from inside our `#save` method, we will use the following:

```ruby
self.class.table_name
```

We can wrap up this code in a handy method, **`#table_name_for_insert`**:

```ruby
def table_name_for_insert
  self.class.table_name
end
```

Great, now let's grab our column names in an abstract manner.

#### Abstracting the Column Names

We already have a handy method for grabbing the column names of the table associated with a given class:

```ruby
self.class.column_names
```

In the case of our `Song` class, this will return:

```ruby
["id", "name", "album"]
```

There's one problem though. When we `INSERT` a row into a database table for the first time, we *don't* `INSERT` the `id` attribute. In fact, our Ruby object has an `id` of `nil` before it is inserted into the table. The magic of our SQL database handles the creation of an ID for a given table row and then we will use that ID to assign a value to the original object's `id` attribute.

So, when we `save` our Ruby object, we should not include the id column name or insert a value for the id column. Therefore, we need to remove `"id"` from the array of column names returned from the method call above:

```ruby
self.class.column_names.delete_if {|col| col == "id"}
```
This will return:

```ruby
["name", "album"]
```

We're almost there with the list of column names needed to craft our `INSERT` statement. Let's take another look at what the statement needs to look like:

```sql
INSERT INTO songs (name, album)
VALUES 'Hello', '25';
```

Notice that the column names in the statement are comma separated. Our column names returned by the code above are in an array. Let's turn them into a comma separated list, contained in a string:

```ruby
self.class.column_names.delete_if {|col| col == "id"}.join(", ")
```

This will return:

```ruby
"name, album"
```

Perfect! Now we have all the code we need to grab a comma separated list of the column names of the table associated with any given class.

We can wrap up this code in a handy method, **`#col_names_for_insert`**:

```ruby
def col_names_for_insert
  self.class.column_names.delete_if {|col| col == "id"}.join(", ")
end
```

Lastly, we need an abstract way to grab the *values* we want to insert.

#### Abstracting the Values to Insert

When inserting a row into our table, we grab the values to insert by grabbing the values of that instance's `attr_reader`s. How can we grab these values without calling the reader methods by name?

Let's break this down.

We already know that the names of that `attr_accessor` methods were derived from the column names of the table associated to our class. Those column names are stored in the `#column_names` class method.

If only there was some way to *invoke* those methods, without naming them explicitly, and capture their return values...

In fact, we already know how to programmatically invoke a method, without knowing the exact name of the method, using the `#send` method.

Let's iterate over the column names stored in `#column_names` and use the `#send` method with each individual column name to invoke the method by that same name and capture the return value:

```ruby
values = []

self.class.column_names.each do |col_name|
  values << "'#{send(col_name)}'" unless send(col_name).nil?
end
```

Here, we push the return value of invoking a method via the `#send` method, unless that value is `nil` (as it would be for the `id` method before a record is saved, for instance).

Notice that we are wrapping the return value in a string. That is because we are trying to craft a string of SQL. Also notice that each individual value will be enclosed in single quotes, `' '`, inside that string. That is because the final SQL string will need to look like this:

```sql
INSERT INTO songs (name, album)
VALUES 'Hello', '25';
```

SQL expects us to pass in each column value in single quotes.

The above code, however, will result in a `values` array

```ruby
["'the name of the song'", "'the album of the song'"]
```

We need comma separated values for our SQL statement. Let's join this array into a string:

```ruby
values.join(", ")
```

Let's wrap up this code in a handy method, **`#values_for_insert`:**

```ruby
def values_for_insert
  values = []
  self.class.column_names.each do |col_name|
    values << "'#{send(col_name)}'" unless send(col_name).nil?
  end
  values.join(", ")
end
```

Now that we have abstract, flexible ways to grab each of the constituent parts of the SQL statement to save a record, let's put them all together into the `#save` method:

#### The `#save` Method:

```ruby
def save
  sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"

  DB[:conn].execute(sql)

  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
end
```

### Selecting Records in a Dynamic Manner

Now that we have a better understanding of how our dynamic, abstract, ORM works, let's build the `#find_by_name` method.

```ruby
def self.find_by_name(name)
  sql = "SELECT * FROM #{self.table_name} WHERE name = #{name}"
  DB[:conn].execute(sql)
end
```

This method is dynamic and abstract because it does not reference the table name explicitly. Instead it uses the `#table_name` class method we built that will return the table name associated with any given class.

## Conclusion

Remember, dynamic ORMs are hard. Spend some time reading over the code in `lib/song.rb` and playing with the code in `bin/run`. Practice creating, saving and querying songs in the `bin/run` file and run the program again and again until you get a better feel for it. 

Now that we have all of these great dynamic, abstract methods that connect a class to a database table, we'll move on to extracting into a parent class that any other class can inherit from.

## Resources
[SQLite- PRAGMA](http://www.tutorialspoint.com/sqlite/sqlite_pragma.htm)

[PRAGMA](https://www.sqlite.org/pragma.html#pragma_table_info)

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/dynamic-orms-readme'>Dynamic ORMs</a> on Learn.co and start learning to code for free.</p>

<p class='util--hide'>View <a href='https://learn.co/lessons/dynamic-orms-readme'>Dynamic ORMs</a> on Learn.co and start learning to code for free.</p>
