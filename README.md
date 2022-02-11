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