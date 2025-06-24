# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Setup

start. 

brew services start postgresql 

stop. 

brew services stop postgresql@14

check status.

pg_ctl -D /opt/homebrew/var/postgresql@14 status



start app. 

rails server
