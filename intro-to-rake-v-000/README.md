# Intro to Rake

## Objectives

1. Introduce Rake and Rake tasks. 
2. Understand what Rake is used for in our Ruby programs.
3. Learn how to build a basic Rake task. 

## What is Rake?

Rake is a tool that is available to us in Ruby that allows us to automate certain jobs––anything from execute SQL to `puts`-ing out a friendly message to the terminal. 

Rake allows us to define something called "Rake tasks" that execute these jobs. Once we define a task, that task can be executed from the command line. 

## Why Rake?

Every program has some jobs that must be executed now and then. For example, the task of creating a database table, the task of making or maintaining certain files. Before Rake was invented, we would have to write scripts that accomplish these tasks in BASH, or we would have to make potentially confusing and arbitrary decisions about what segment of our Ruby program would be responsible for executing these tasks. 

Writing scripts in BASH is tough, and BASH just isn't as powerful as Ruby. On the other hand, for each developer to make his or her own decisions about where to define and execute certain common tasks related to databases or file maintenance is confusing. 

Rake provides us a standard, conventional way to define and execute such tasks using Ruby. 

## Where did Rake Come From?

In fact, the C community was the first to implement the pattern of writing all their recurring system maintenance tasks in a separate file. They called this file the MakeFile because it was generally used to gather all of the source files and make it into one compiled executable file. 

Rake was later developed by [Jim Weirich](https://en.wikipedia.org/wiki/Jim_Weirich) as the task management tool for Ruby. 

## How to Define and Use Rake Tasks

Building a Rake task is easy, since Rake is already available to us as a part of Ruby. All we need to do is create a file in the top level of our directory called `Rakefile`. Here we define our task:

```ruby
task :hello do
  # the code we want to be executed by this task 
end
```

We define tasks with `task` + `name of task as a symbol` + a block that contains the code we want to execute. 

If you open up the `Rakefile` in this directory, you'll see our `:hello` task:

```ruby
task :hello do 
  puts "hello from Rake!"
end
```

Now, in your terminal in the directory of this project, type:

`rake hello`

You should see the following outputted to your terminal:

```bash
hello from Rake!
```

### Describing our Tasks for `rake -T`

Rake comes with a handy command, `rake -T`, that we can run in the terminal to view a list of available Rake tasks and their descriptions. In order for `rake -T` to work though, we need to give our Rake tasks descriptions. Let's give our `hello` task a description now:

```ruby
desc 'outputs hello to the terminal'
task :hello do 
  puts "hello from Rake!"
end
```

Now, if we run `rake -T` in the terminal, we should see the following:

```bash
rake hello       # outputs hello to the terminal
```

So handy!

### Namespacing Rake Tasks

It is possible to namespace your Rake tasks. What does "namespace" mean? A namespace is really just a way to group or contain something, in this case our Rake tasks. So, we might namespace a series of greeting Rake tasks, like `hello`, above, under the `greeting` heading. 

Let's take a look at namespacing now. Let's say we create another greeting-type Rake task, `hola`:

```ruby
desc 'outputs hola to the terminal'
task :hola do 
  puts "hola de Rake!"
end
```

Now, let's namespace both `hello` and `hola` under the `greeting` heading:

```ruby
namespace :greeting do 
desc 'outputs hello to the terminal'
  task :hello do 
    puts "hello from Rake!"
  end
  
  desc 'outputs hola to the terminal'
  task :hola do 
    puts "hola de Rake!"
  end
end
```

Now, to use either of our Rake tasks, we use the following syntax:

```bash
rake greeting:hello
hello from Rake!

rake greeting:hola
hola de Rake!
```

## Common Rake Tasks

As we move towards developing Sinatra and Rails web applications, you'll begin to use some common Rake tasks that handle the certain database-related jobs. 

### `rake db:migrate`

One common pattern you'll soon become familiar with is the pattern of writing code that creates database tables and then "migrating" that code using a rake task. 

Our `Student` class currently has a `#create_table` method, so let's use that method to build out our own `migrate` Rake task. 

We'll namespace this task under the `db` heading. This namespace will contain a few common database-related tasks.

We'll call this task `migrate`, because it is a convention to say we are "migrating" our database by applying SQL statements that alter that database.

```ruby
namespace :db do
  desc 'migrate changes to your database'
  task :migrate => :environment do
    Student.create_table
  end
end
```

Now, if we run `rake db:migrate`, our database table will be created. 

#### Task Dependency

You might be wondering what is happening with this snippet:

```ruby
task :migrate => :environment do 
...
```

This creates a *task dependency*. Since our `Student.create_table` code would require access to the `config/environment.rb` file (which is where the student class and database are loaded), we need to give our task access to this file. We can do so by defining yet another Rake task that we can tell to run before the `migrate` task is run. 

Let's check out that `environment` task:

```ruby
# in Rakefile

task :environment do
  require_relative './config/environment'
end
```

### `rake db:seed`

Another task you will become familiar with is the `seed` task. This task is responsible for "seeding" our database with some dummy data. 

The conventional way to seed your database is to have a file in the `db` directory, `db/seeds.rb`, that contains some code to create instances of your class. 

If you open up `db/seeds.rb` you'll see the following code to create a few students:

```ruby
require_relative "../lib/student.rb"

Student.create(name: "Melissa", grade: "10th")
Student.create(name: "April", grade: "10th")
Student.create(name: "Luke", grade: "9th")
Student.create(name: "Devon", grade: "11th")
Student.create(name: "Sarah", grade: "10th")
```

Then, we define a rake task that executes the code in this file. This task will also be namespaced under `db`:

```ruby
namespace :db do

  ...
  
  desc 'seed the database with some dummy data'
  task :seed do 
    require_relative './db/seeds.rb'
  end
end
```

Now, if we run `rake db:seed` in our terminal (provided we have already run `rake db:migrate` to create the database table), we will insert five records into the database. 

If only there was some way to interact with our class and database without having to run our entire program...

Well, we can build a Rake task that will load up a Pry console for us. 

### `rake console`

We'll define a task that starts up the Pry console. We'll make this task dependent on our `environment` task so that the `Student` class and the database connection load first. 

```ruby
desc 'drop into the Pry console'
task :console => :environment do
  Pry.start 
end
```

Now, provided we ran `rake db:migrate` and `rake db:seed`, we can drop into our console with the following:

```bash
rake console
```

This should bring up the following in your terminal:

```bash
[1] pry(main)>
```

Let's check to see that we did in fact successfully migrate and seed our database:

```bash
[1] pry(main)> Student.all
=> [[1, "Melissa", "10th"],
 [2, "April", "10th"],
 [3, "Luke", "9th"],
 [4, "Devon", "11th"],
 [5, "Sarah", "10th"]]
```

We did it!

<p class='util--hide'>View <a href='https://learn.co/lessons/intro-to-rake'>Intro to Rake</a> on Learn.co and start learning to code for free.</p>
