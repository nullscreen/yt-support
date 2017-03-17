Common code needed by the other Yt gems
=======================================

Yt::Support provides common functionality to all Yt gems.
It is considered suitable for internal use only at this time.

The **source code** is available on [GitHub](https://github.com/fullscreen/yt-support) and the **documentation** on [RubyDoc](http://www.rubydoc.info/gems/yt-support/frames).

[![Build Status](http://img.shields.io/travis/fullscreen/yt-support/master.svg)](https://travis-ci.org/fullscreen/yt-support)
[![Coverage Status](http://img.shields.io/coveralls/fullscreen/yt-support/master.svg)](https://coveralls.io/r/fullscreen/yt-support)
[![Dependency Status](http://img.shields.io/gemnasium/fullscreen/yt-support.svg)](https://gemnasium.com/fullscreen/yt-support)
[![Code Climate](http://img.shields.io/codeclimate/github/fullscreen/yt-support.svg)](https://codeclimate.com/github/fullscreen/yt-support)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://www.rubydoc.info/gems/yt-support/frames)
[![Gem Version](http://img.shields.io/gem/v/yt-support.svg)](http://rubygems.org/gems/yt-support)

Yt::Support provides:

* [Yt.configure](http://www.rubydoc.info/gems/yt-support/Yt/Config#configure-instance_method)
* [Yt::Configuration](http://www.rubydoc.info/gems/yt-support/Yt/Configuration)

How to contribute
=================

Contribute to the code by forking the project, adding the missing code,
writing the appropriate tests and submitting a pull request.

In order for a PR to be approved, all the tests need to pass and all the public
methods need to be documented and listed in the guides. Remember:

- to run all tests locally: `bundle exec rspec`
- to generate the docs locally: `bundle exec yard`
- to list undocumented methods: `bundle exec yard stats --list-undoc`
