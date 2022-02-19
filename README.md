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

## 2022-02-13

Blarg, burnt too much time with Trix, I don't care that much (yet) about the text field options, so I'm going to pick up a different thread for now. 

I want to do things with "maps" in Rails. I've got a specific target endpoint, but for now, I'm going to see if I can do, in this session, at least a few things, more or less in this order:

1. Get a 'leaflet' map embedded on `book_quotes#index`
2. get the same map that I have on https://github.com/josh-works/strava_run_polylines_osm/tree/main embedded on `book_quotes#index`
3. Add an IP address to each book quote, bound to a certain area, render pins on `book_quotes#index`


First piece was easy. Lets make the actual runs show up now. 

https://stackoverflow.com/questions/22900904/setting-up-leaflet-with-ruby-on-rails

## 2022-02-14

Spent a little more time on this.

This morning, I managed to refresh my broken authentication stuff w/the Strava API (and w/Oauth):

- https://cryptic-sea-38287.herokuapp.com/
- https://github.com/josh-works/strava_run_polylines_osm/tree/main

---------

big progress. Getting lines rendered in rails. But really, _really_ struggling to pass them in from the view.

I'd hoped to mock up something quick-and-dirty with hardcoding an instance variable from the controller, but having a bitch of a time getting it visible to the JS function in the view.

https://stackoverflow.com/questions/2464966/how-to-pass-ruby-variables-to-a-javascript-function-in-a-rails-view/24456817#24456817

I'm not the only one. How is this not a better-discussed problem? I basically cannot get a well-encoded polyline from the controller to the view. In my `script` tags, i have to do a weird view thing:

```javascript
var runPolyLines = <%= @runs %>
console.log(runPolyLines)
```
but what gets written to the `@runs` ivar in the controller:

![runs](/images/polyline.jpg)

it even looks fine when I did a "test" render to the view:

![close](/images/so-close.jpg)

But when you inspect the HTML, you'll see that there's a lot of escaping going on.

That escaping is causing the javascript to blow up. Sigh. Here's my javascript:

```html
<!-- app/views/strava_runs/index.html.erb -->
<script type="text/javascript">
        var polyLines = <%= @runs %>
</script>
```

This causes an error:

```
Uncaught SyntaxError: expected expression, got '&'
```

And when I inspect the Javascript manifest, I see:


![fucking-quot](/images/quot.jpg)

Sigh. Something related to `html_safe`, I think. I've tried a lot of stupid debugging tricks, no dice. 

Any ideas? 

Here's what DOES work:

```html
<script type="text/javascript">
  var map = L.map('map').setView([39.748733, -105.220105], 13);
  L.tileLayer(
      'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          maxZoom: 18,
      }).addTo(map);
      var polyLines = [
        "kyuqFzsgaSI@ED@HC?MBAHNl@b@v@x@nBLRJb@RDh@o@\m@|AqBjAqA|AqAh@g@pByA~@_Az@s@~DcEbB{A`@[l@]A@FA??dAs@dAiAvCqCt@{@`DyCxAoAf@k@\QZYX]hBcB~@s@dCuBvAyAfA_AR@HH`AbCNTN?DOFDKJCK@OADEIBLLGDBQEK[IE_@y@BDAPGJ?FGBS@s@v@I@KMKG?BHDGE@@@CSF}NlIsFnD]X[V~Q{I^k@\o@lBmBn@]\R@Q^G",
        "mqsqFj`faS@X?Ig@h@}@p@IGa@gAMMKAOFIJKDSX]XEHQLCHe@^oAlAoAdAc@Zo@h@QHSGGe@Sa@gAiCmAcCQo@KGGKgAeCOUGSKICJ?JHL?j@@z@Ad@E\Wp@w@bAiDtCuAvAa@P]FIFYX]NI?QMq@H{AGc@BgAEF?BNACJFAEAA@BA?CKCBICL??DG?@CEAJ?ABBEG?DBEADAGE@?DB@HGHGAKII?wCTg@?]CI@SC_@Bk@EUBGF]`ASXQv@Cj@?l@Iz@BNEZ_@n@s@`Aa@Tg@TKHY\yA|@APDLLJPFXZDJDd@?d@BTJVNRTr@GXKPUTSLW\SLe@f@CF?HX\l@lAPf@FHFDHIHCDDCAJSB??ECBDA"
      ]
      console.log(polyLines);

  for (var i = 0; i < polyLines.length; i++) {
    console.log(polyLines[i]);
  }
  for (let encoded of polyLines ) {
    var coordinates = L.Polyline.fromEncoded(encoded).getLatLngs();

    L.polyline(
        coordinates,
        {
            color: 'blue',
            weight: 3,
            opacity: .7,
            lineJoin: 'round'
        }
    ).addTo(map);
  }
  
</script>
```

![works](/images/functioning.jpg)

### Question

I want to be able to have a list of Polylines generated in the controller available to my javascript in my view page, so I can modify the `Leaflet` map. I thought this would be easy, but it's been surprisingly difficult.

Do you know how to do this? How to get polylines from a controller into a javascript function, so I can iterate through each one of them?

Remember, this JS works:

```javascript
var polyLines = [ "kyua@", "mqsqF" ]
for (var i = 0; i < polyLines.length; i++) {
  map.draw(polyLines[i]);
}
```
but this is what I'm getting in the actual HTML of the page:


```
var polyLines = [&quot;kyua@&quot;, &quot;mqsqF&quot; ]
for (var i = 0; i < polyLines.length; i++) {
  map.draw(polyLines[i]);
}
```

I'll look up one-off JS files that might pair with views. How would you do this? Any suggestions?

Here's some of the resources I have read, and tested as well as I could various implementations of these fixes:

- https://stackoverflow.com/questions/2464966/how-to-pass-ruby-variables-to-a-javascript-function-in-a-rails-view/24456817#24456817

ugh, too many to copy-paste. I feel _so_ dumb:

![i feel dumb](/images/i-feel-dumb.jpg)


## 2022-02-18

https://codequizzes.wordpress.com/2013/06/06/rails-javascript-workflow-rendering-javascript-partials/

