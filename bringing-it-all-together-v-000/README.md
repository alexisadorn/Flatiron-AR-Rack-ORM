# Basic Dog ORM

## Objectives
* Understand what an Object Relational Mapper(ORM) is.
* Gain ability to implement characteristics of an ORM when using a relational database management system (RDBMS) in a ruby program.

## Instructions
This lab involves building a basic ORM for a Dog object.  The `Dog` class defined in `lib/dog.rb` implements behaviors of a basic ORM.


- **Environment**
  Our environment is going to be a single point of requires and loads.  It is also going to define a constant, `DB`, whose sole responsibility is setting up and maintaining connection to our application's database.
   - `DB = {:conn => SQLite3::Database.new("db/dogs.db")}`
   `DB` is set equal to a hash, which has a single key, `:conn`. The key, `:conn`,  will have a value of a connection to a sqlite3 database in the db directory.

      However, in our spec_helper, which is our testing environment, we're going to redefine the value of that key (not of the constant) to point to an in-memory database. This will allow our tests to run in isolation of our production database. Whenever we want to refer to the applications connection to the database, we will simply rely on `DB[:conn]`.

## Solving The Lab: The Spec Suite

###Start with these methods

-  **`#attributes`**

  The first test is concerned solely with making sure that our dogs have all the required attributes and that they are readable and writeable.

  The `#initialize` method accepts a hash or keyword argument value with key-value pairs as an argument. key-value pairs need to contain id, name, and breed.

-  **`::create_table`**
  Your task  here is to define a class method on Dog that will execute the correct SQL to create a dogs table.

```ruby
describe '::create_table' do
  it 'creates a dogs table' do
    DB[:conn].execute('DROP TABLE IF EXISTS dogs')
    Dog.create_table

    table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
    expect(DB[:conn].execute(table_check_sql)[0]).to eq(['dogs'])
  end
end
```

  Our test first makes sure that we are starting with a clean database by executing the SQL command `DROP TABLE IF EXISTS dogs`.

  Next we call the soon to be defined `create_table` method, which is responsible for creating a table called dogs with the appropriate columns.

-  **`::drop_table`**
This method will drop the dogs table from the database.

```ruby
  describe '::drop_table' do
    it "drops the dogs table" do
        Dog.drop_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
      expect(DB[:conn].execute(table_check_sql)[0]).to be_nil
    end
  end
```

  It is basically the exact opposite of the previous test. Your job is to define a class method on `Dog` that will execute the correct SQL to drop a dogs table.

- **`::new_from_db`**

  This is an interesting method. Ultimately, the database is going to return an array representing a dog's data. We need a way to cast that data into the appropriate attributes of a dog. This method encapsulates that functionality. You can even think of it as  `new_from_array`. Methods like this, that return instances of the class, are known as constructors, just like `::new`, except that they extend the functionality of `::new` without overwriting `initialize`.

- **`::find_by_name`**

  This spec will first insert a dog into the database and then attempt to find it by calling the find_by_name method. The expectations are that an instance of the dog class that has all the properties of a dog is returned, not primitive data.

  Internally, what will the `find_by_name` method do to find a dog; which SQL statement must it run? Additionally, what method might `find_by_name` use internally to quickly take a row and create an instance to represent that data?

- **`#update`**

  This spec will create and insert a dog, and after, it will change the name of the dog instance and call update. The expectations are that after this operation, there is no dog left in the database with the old name. If we query the database for a dog with the new name, we should find that dog and the ID of that dog should be the same as the original, signifying this is the same dog, they just changed their name.

- **`#save`**

  This spec ensures that given an instance of a dog, simply calling `save` will trigger the correct operation. To implement this, you will have to figure out a way for an instance to determine whether it has been persisted into the DB.

  In the first test we create an instance, specify, since it has never been saved before, that the instance will receive a method call to `insert`.

  In the next test, we create an instance, save it, change its name, and then specify that a call to the save method should trigger an `update`.

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/bringing-it-all-together' title='Basic Dog ORM'>ORMs Lab: Bringing It All Together</a> on Learn.co and start learning to code for free.</p>
