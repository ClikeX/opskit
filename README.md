[![Code Climate](https://codeclimate.com/github/ClikeX/opskit/badges/gpa.svg)](https://codeclimate.com/github/ClikeX/opskit)[![Build Status](https://travis-ci.org/ClikeX/opskit.svg?branch=develop)](https://travis-ci.org/ClikeX/opskit)[![Build Status](https://drone.io/github.com/ClikeX/opskit/status.png)](https://drone.io/github.com/ClikeX/opskit/latest)

OpsKit
======

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/opskit`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO:
* Intergrate project type checking for wordpress / ruby specific tasks
* Try to copy db from seraver with ask or capistrano config parsing

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'opskit'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install opskit
```

Usage
-----

```
Commands:
  opskit clean           # Cleans a project from your system
  opskit help [COMMAND]  # Describe available commands or one specific command
  opskit setup           # Setup a project based on a git repository
```

Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
------------

1.	Fork it ( https://github.com/[my-github-username]/opskit/fork )
2.	Create your feature branch (`git checkout -b my-new-feature`\)
3.	Commit your changes (`git commit -am 'Add some feature'`\)
4.	Push to the branch (`git push origin my-new-feature`\)
5.	Create a new Pull Request
