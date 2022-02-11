Re-doing Steve's `rails authentication from scratch` tutorial: https://stevepolito.design/blog/rails-authentication-from-scratch/

My first time through, I recorded all of my notes here: https://github.com/josh-works/rails-authentication-from-scratch/tree/main

second time through, I got sidetracked, but it had some good detours: https://github.com/josh-works/rails-auth-from-scratch-02

For practice, I'm planning deviating from the tutorial in small ways and large, to reinforce my mental models of how it's all working.

Sigh... this is copy-pasted from a failed attempt. I tried to do fancy stuff with the data models, and didn't get it quite right, botched some migrations, and it'll take me longer to unbreak it than it would to just generate another app from scratch.

For example, `--css=tailwind` didn't work. why? I don't know.

Here we go, again:

## step 0: 

```
$ gem update rails 
=> 7.0.2
$ which ruby
=> 3.0.1

$ gem install bundler:2.2.17
rails _7.0.2_ new rails-auth-from-scratch-03 -d postgresql -css tailwind
```

## Step 0.1: Install tailwind for real?

From the tailwind docs: https://tailwindcss.com/docs/guides/ruby-on-rails

```
./bin/bundle add tailwindcss-rails
./bin/rails tailwindcss:install
```

Boot the app now with:

```
bin/dev
```

## Step 1: Build User Model

```
rails g model User email:string nickname:string first_name:string last_name:string avatar:string
```

Add `faker` and `pry-rails` gems, index `users` on email

```
b rails g scaffold BookQuote quote:string book_title:string user:references
```

Add a `has_many` to our `User` model. Here's what I've got in my seeds file:

```ruby
# db/seeds.rb
5.times do
  User.find_or_create_by(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    avatar: Faker::Avatar.image(size: "50x50", format: "jpg"),
    # password_digest: "password"
  )
end

100.times do 
  quote = Faker::Movie.quote
  book_title = Faker::Book.title
  submitted_by = User.order("RANDOM()").first
  BookQuote.create(quote: quote, book_title: book_title, user: submitted_by)
end
```

```
rails db:setup
rails db:seed
```
In `routes.rb`, set `root to: 'book_quotes#index'`


And now fire up your rails server and visit http://localhost:3000/

Sweet, sweet Tailwind, along with "good enough" seed data.

-------------

## To Explore

### N+1

I noticed a slew of DB calls (printed in the logs) when I swapped `book_quote.user_id` to `book_quote.user.first_name` and loaded the home page.

In `app/views/book_quotes/_book_quote.html.erb`, the scaffold generated:

```HTML+ERB
<p class="my-5">
  <strong class="block font-medium mb-1">User:</strong>
  <%= book_quote.user_id %>
</p>
```

Which just prints out integers. Not great. When I change to:

```HTML+ERB
<p class="my-5">
  <strong class="block font-medium mb-1">User:</strong>
  <%= book_quote.user.first_name %>
</p>
```

This kicks off a ton of DB calls. (An `n+1`, technically)

Question: What's the quickets way to fix this?

Answer: 
Here's what we have:

```ruby
# book_quotes_controller.rb
# GET /book_quotes or /book_quotes.json
def index
  @book_quotes = BookQuote.all
end
```

When we change it to the following, it becomes a single query again:

```ruby
# GET /book_quotes or /book_quotes.json
def index
  @book_quotes = BookQuote.all.includes(:user)
end
```