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

OK, added a navbar via Tailwind, which I worked on originally here: https://github.com/josh-works/turbo-pagination/tree/main#tailwind-navbar

There's lots more notes there, but this was mostly a copy-paste job. I would like to practice re-building from scratch. I think it'll be worth it, but I'll do that after I re-do at least the first half of the auth tutorial.


## Step 2: add confirmed_at and password_digest columns

```
> rails g migration add_confirmed_at_and_password_columns_to_users confirmed_at:datetime password_digest:string
```

To run the migrations, you've got to delete all users, which means you'll have to delete all the book quotes that depend upon them. Fire up the rails console:

```ruby
BookQuote.destroy_all
User.destroy_all
```

uh, don't do that in a prod-like environment, duh. 

## Step 3 create signup pages

```
$ rails g controller Users create new
```

Here's what we've got, end of step 3:

![it works](/images/create_user.jpg)

## Step 4: create confirmation pages

https://stevepolito.design/blog/rails-authentication-from-scratch/#step-4-create-confirmation-pages

I'll pick up here next time. I'm liking how this whole tutorial is taking shape.

# 2022-02-12

Going to take a detour (and make a branch! How fancy! you should do the same) to explore a feature that will look like so, in my mind/map:

- [ ] figure out how to use Trix editor (right? That's Basecamp's WYSIWYG editor) and tailwind for "longblob" text content
- [ ] attach longblob to existing BookQuote model
- [ ] stash this all on a separate branch until it's working. avoid commiting this actual file (readme.md) to the other branch, else the sequential/iterative flow of the document _might_ get a bit muddled.
- [ ] Create a new `MobilityImprovementIdea` scaffold, where my primary 'acceptance criteria' is that there's a little map that lets me store it with a pin on a map.
- [ ] on an index page render a page with all pins are rendered on a map somehow. I'd prefer leaflet or mapbox?

these might all happen on separate days/sessions. 

OK, got https://github.com/josh-works/rails-auth-from-scratch-03/issues/1 up 

```
$ hub browse --issues
```

opens the issues page.

ran `rails action_text:install`, via https://levelup.gitconnected.com/trix-rich-editor-for-your-rails-6-application-7b89e2f33de8

VIPS stuff. Please see the comment I left on this particular issue.

Might need to add `gem install image_processing` to my Gemfile. 

Taking so much time... https://twitter.com/josh_works/status/1492431136760287233

## 2022-02-12

 > NoMethodError (undefined method `create' for ActionDispatch::Response:Class):

The next day. Phew. I think i installed that library. I did `gem install ` worked, all the code is up and running. 

Also:

```
$ gem install ruby-vips
$ export DISABLE_SPRING=true
```

I lost track of what I was doing, decided to throw the branch away and go from scratch again, and it's worth it. I saw this in the logs:

```
Ensure image_processing gem has been enabled so image uploads will work (remember to bundle!)
```

Lets do that

`gem install image_processing`, `bundle install`, etc:

![steps](/images/add-image-magic.jpg)

let's run `bin/dev` again, see what we get.

Hm, had to unbreak migrations problems. I'd run these migrations on a different branch, so the tables existed, was causing errors. Fixed with:

```ruby
unless table_exists?(:table_name)
  create_table :table_name, id: primary_key_time do |t|
```

Everything looks good. I've got ActionText installed and the DB/server ready for it, but I've not (this time around) modified the view to display the trix editor. 

![before](/images/pre-trix.jpg)

Let's update the view. Should be a one-liner?

```diff
 --git a/app/views/book_quotes/_form.html.erb b/app/views/book_quotes/_form.html.erb
index 1772724..7576289 100644
--- a/app/views/book_quotes/_form.html.erb
+++ b/app/views/book_quotes/_form.html.erb
@@ -13,7 +13,7 @@

   <div class="my-5">
     <%= form.label :quote %>
-    <%= form.text_field :quote, class: "block shadow rounded-md border border-gray-200 outline-none px-3 py-2 mt-2 w-full" %>
+    <%= form.rich_text_area :quote, class: "block shadow rounded-md border border-gray-200 outline-none px-3 py-2 mt-2 w-full" %>
   </div>

   <div class="my-5">
```

That might be hard to read. I just changed `form.text_field` to `form.rich_text_area`. Whoa.

![the change](/images/one-line.jpg)

So cool. It even saves correctly, but doesn't get rendered quite right.

Now when I save it, though, It renders nooooot quite right:

![not right](/images/not-what-we-want.jpg)


I want to render this quote now in the way it looks in trix, like this:

eh, it's not realllllly working quite right, maybe? I have not used it enough to know. Images deff don't work quite right, though they work in the editor:

![broken](/images/broke.jpg)


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

## Actually sending email in production

- https://docs.sendgrid.com/for-developers/sending-email/rubyonrails
- https://docs.sendgrid.com/for-developers/sending-email/quickstart-ruby
- https://devcenter.heroku.com/articles/smtp

## Making habit of github issues linked to PRs? Might help with commit tracing?

## `rails db:migrate:status`

I'm doing more with lots of migrations. Up, down, change, etc. 

rails db:migrate failing with:

![fail](/images/relation_exists.jpg)

The fix: 

https://stackoverflow.com/questions/7874330/rake-aborted-table-users-already-exists, I did this solution: https://stackoverflow.com/a/23362525/3210178

Check the commits: 006143eee21850e3439ed8c1a239593a4d0c0d47

