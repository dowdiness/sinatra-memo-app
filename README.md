# Sinatra Memo App

Simple note taking application built by Sinatra

## Installation

Make sure you already installed [rbenv](https://github.com/rbenv/rbenv)

```bash
rbenv install 3.0.3

gem install bundler

bundle install

bundle exec ruby main.rb
```

You can see Memo application running on http://localhost:4567

## Screenshots

### /

#### Empty Top Page

![Empty Top Page](screenshots/empty.png)

#### Top Page with data

![Top Page with data](screenshots/index.png)

### /new

#### New memo

![New memo](screenshots/new.png)

### /:id

#### Show memo

![Show memo](screenshots/show.png)

### /:id/edit

#### Edit memo

![Edit memo](screenshots/edit.png)

### /reset

#### Delete all memos

![Delete all memos](screenshots/reset.png)

### /not_found

#### If page not found

![404 page](screenshots/404.png)
