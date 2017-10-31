# Inspecting The Web With Rack

##  Objectives
1. Explain the mechanics of Rack 
2. Create a basic web app 
3. Set up an HTTP web server using a `config.ru` file and the `rackup` command

## Why Rack? 

We've learned how the web works so far using abstract concepts. Problem is, when you are dealing with massive websites like YouTube or Facebook it's hard to fully understand the moving parts because there are so many of them. Thankfully, there is a gem for Ruby that will help us create a web server at its simplest. This gem is called [Rack](https://rack.github.io/) and it is what Rails is built on top of. Before we get to the complexity of Rails, let's first understand HTTP in its simplest form.

Let's start by getting the mechanics of Rack working.

## Setting up Rack

To work with Rack we need to create a new class that responds to a single method: `#call`. All this method needs to do is return a response which consists of the status code, any headers, and the body. This can all be done using the `Rack::Response` object. 

Using this, let's create a basic web app. Follow along with the below instructions. 

We first create a `Rack::Response` object, then add some text "Hello, World" to the body, and complete the response with the `#finish` method. By default, Rack sets our status codes and headers. Don't worry about the `env` input. This holds all of the *request* info in it and we will use it later!

```ruby
class Application

  def call(env)
    resp = Rack::Response.new
    resp.write "Hello, World"
    resp.finish
  end

end
```

The above is the code that will be run whenever there is a request received.  But we have one more step. We need to actually set up an HTTP web server that will receive the HTTP request, send it through the above `#call` method, and then serve the response to the browser. We do this using a `config.ru` file and the `rackup` command. Our `config.ru` file should look like this:

```ruby
#config.ru
require_relative "./application.rb"

run Application.new
```

To run this code we then run `rackup config.ru`. If you're using an Integrated Development Environment, such as Nitrous, you may need to use `rackup config.ru -b 0.0.0.0` or `rackup config.ru --host 0.0.0.0`. Everything goes as planned, you'll see:

```
[2015-11-27 16:48:22] INFO  WEBrick 1.3.1
[2015-11-27 16:48:22] INFO  ruby 2.1.3 (2014-09-19) [x86_64-darwin13.0]
[2015-11-27 16:48:22] INFO  WEBrick::HTTPServer#start: pid=11275 port=9292
```

Notice it says `port=9292`. If you open your browser and go to `http://localhost:9292/` you should see `Hello, World`. 

>Note: If you're using the Learn IDE, you won't be able to get to your website with `localhost`. Instead, you'll see a line that looks something like this - `Starting server on 159.203.101.28:30001`. To see the webpage, just go to `159.203.101.28:30001` in your web browser. Anywhere these instructions tell you to go to `localhost`, replace that with this IP address instead!

Let's deconstruct this URL a little bit though. The URL is `http://localhost:9292/`. The protocol is `http`. That makes sense, but the domain is `localhost:9292`. What's going on there? `localhost` is normally where a server like `google.com` goes. In this case, since you are running the server on your computer, `localhost` is the server name of your own computer. Nobody else can get that URL though. That's good for right now. This allows you to play around with writing websites without the security concerns of opening it up to the entire web. The last part of that URL is the `:9292` section. This the "port number" of your server. Don't worry too much about this, but you may want to run multiple servers on one computer and having different ports allows them to be running simultaneously without conflicting. The resource that you are requesting is `/`. This is effectively like saying the home or default.

Now it's your turn. Modify your app to introduce yourself by saying "Hello, my name is <YOUR NAME>". To exit the running web server and get back to your terminal press CTRL-C. **You will have to do this every time you change your code**.
<p class='util--hide'>View <a href='https://learn.co/lessons/rack-intro'>Inspecting the Web with Rack</a> on Learn.co and start learning to code for free.</p>
