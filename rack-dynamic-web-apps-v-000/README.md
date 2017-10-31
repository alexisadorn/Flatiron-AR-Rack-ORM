# Dynamic Web Apps with Rack

## Objectives

1. Translate a command line Ruby app to a dynamic web app
2. Use the `#write` method in a `Rack::Response` object to make a dynamic web app in Rack

## Creating a Dynamic Web App

Making web apps that always give the same response are boring. Programming is fun because of its ability to create dynamic responses that change depending on the input. A dynamic web app in Rack is pretty straightforward. Let's say we wanted to create a simple slots game.

First, let's set up our basic Rack app:

```ruby
class Application

  def call(env)
    resp = Rack::Response.new
    resp.write "Hello, World"
    resp.finish
  end

end
```

Then run it with `rackup config.ru`. You should see something like

```shell
[2016-07-28 10:09:08] INFO  WEBrick 1.3.1
[2016-07-28 10:09:08] INFO  ruby 2.3.0 (2015-12-25) [x86_64-darwin15]
[2016-07-28 10:09:08] INFO  WEBrick::HTTPServer#start: pid=38967 port=9292
```

Make note of `port=9292` — that shows which port we'll access the application on
in the browser. But what's the host? If we're developing locally, we can just
use `localhost` — so in this case we'd visit `http://localhost:9292`.

If we're using the IDE, we should also see a line like

```shell
Starting server at 104.131.138.76:6868
```

That is the full URL to use. (**Yours will most likely be different!**) So in
this case, we'd visit http://104.131.138.76:6868 in the browser. If we're using
the IDE, **localhost will not work**.

When we visit the appropriate URL in our browser, we should see "Hello, World".
Let's liven things up a bit. The amazing part of Rack and everything (like
Rails) that is built on top of Rack is that it's *just Ruby*. If you were
writing a command line slots game generator, you would first need to generate
three numbers between 1 and 20. You could do that like this:

**NOTE**: Don't sweat the `Kernel` bit — [Kernel](http://ruby-doc.org/core-2.3.0/Kernel.html)
is a module that holds many of Ruby's most useful bits. We're just using it here
to generate some random numbers.

```ruby
num_1 = Kernel.rand(1..20)
num_2 = Kernel.rand(1..20)
num_3 = Kernel.rand(1..20)
```

Then, to check to see if you won or not, we'd have an if statement like this:

```ruby
num_1 = Kernel.rand(1..20)
num_2 = Kernel.rand(1..20)
num_3 = Kernel.rand(1..20)

if num_1==num_2 && num_2==num_3
  puts "You Win"
else
  puts "You Lose"
end
```

So how do we now make this application work on the web? Almost none of the code actually is specific to a command line interface. The only parts that require a command line are the two `puts` lines. All that needs to change to adapt this for the web is a different way than `puts` to express output to our user. Because this is the web, that means adding it to our response. Instead of `puts` now we'll use the `#write` method in our `Rack::Response` object.

Remember that to modify our web server, we have to first exit out of the running server by typing CTRL-C. Then open up your Application and modify it to look like this:

```ruby
class Application

  def call(env)
    resp = Rack::Response.new

    num_1 = Kernel.rand(1..20)
    num_2 = Kernel.rand(1..20)
    num_3 = Kernel.rand(1..20)

    if num_1==num_2 && num_2==num_3
      resp.write "You Win"
    else
      resp.write "You Lose"
    end

    resp.finish
  end

end
```

Notice that we only changed the `puts` statements into `resp.write` statements. That's it! Web servers are just big ruby apps that respond to the user in an HTTP response rather than via `puts` statements. Let's give the user a bit more information about what numbers they received by writing the numbers to the response as well. The `#write` method can be called many times to build up the full response. The response isn't sent back to the user until `#finish` is called.

```ruby
class Application

  def call(env)
    resp = Rack::Response.new

    num_1 = Kernel.rand(1..20)
    num_2 = Kernel.rand(1..20)
    num_3 = Kernel.rand(1..20)

    resp.write "#{num_1}\n"
    resp.write "#{num_2}\n"
    resp.write "#{num_3}\n"

    if num_1==num_2 && num_2==num_3
      resp.write "You Win"
    else
      resp.write "You Lose"
    end

    resp.finish
  end

end
```

The `\n`s are just a special character which gets rendered by the browser as a new line. Kill your running server with CTRL-C and re-run it and refresh your browser. Feel free to cheat a bit and change the random numbers to just be between one and two. That way you can test that both work.

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/rack-dynamic-web-apps' title='Dynamic Web Apps with Rack'>Dynamic Web Apps with Rack</a> on Learn.co and start learning to code for free.</p>
