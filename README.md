
# Twitter Research Ruby

A data mining tool that provides convienient methods to gather Twitter data
using Ruby and Twitter API V2.

## Usage

Fetching data has lots of limitation - at least with the free API plans -
therefor you'll need to consider keeping your data mining processes running for
quite a while. Its highly recommended to use a machine with low-power
consumption like a Raspberry Pi.

```sh
$ ruby -v # have at least ruby version 3.1
# NOTE: gem not published, download repository instead
# $ gem install twitter-research

# creates ~/.config/twitter-research.yml configuration file and
# ~/twitter-research-data/ directory.
$ $EDITOR ~/.twitter-research.yml # set your api-key
```

The following snippet does collect an egocentric network using friends
(alter that follow the ego). Running the process does create files in the data
directory, information is stored in JSON format. Existing files do prevent API
request and ensure a process can be re-run w/o starting all over or causing
conflicts (idempotency).

```ruby
require 'twitter-research'

TwitterResearch.api_token = '...'
TwitterResearch.data_directory = File.join(__dir__, 'results')

# Select the center (ego) of our network.
ego = TwitterResearch::User.find '@lipdaguit'
# Fetch all alter users (direct friends).
TwitterResearch::Task.create :users, ego.friend_ids
# Fetch friends of friends, note that this also includes users that won't be
# friends of the ego and have to be ignored constructing the network.
TwitterResearch::Task.create :friends, ego.friend_ids
```

The default logger will store detailed log information in
`~/twitter-research-data/.twitter-research.log`.

## Configuration

```yaml
# file: ./.twitter-research.yml or ~/.config/twitter-research.yml
---
# the Bearer Token at Twitter API
api_key: '...'
# store data locally in json formatted files
data_directory: '~/twitter-research/'
```

## Development

```sh
$ make test # run testsuite
$ make watch # run testsuite on file change
```

## DSL Proposal

Features: Progress Updates, Logging, Error Handling, Retry Management,
Storage Handling.

```ruby
#!/usr/bin/env ruby

include TwitterResearch::DSL

configure!

# stored will skip the block if there is already data present. on error
# stored will also retry depending on the error received. e.g. if there
# is a wait time present, it will wait for this time.
user = stored 'lipdaguit' do
  twitter(:user).find_by_name screen_name
end
followers = stored "#{screen_name}-followers" do
  twitter(:followers).find user.id
end
followers.each do |follower|
  stored "#{follower}-followers" do
    twitter(:followers).find follower.id
  end
end
```

## Rake Task

In case you want to handle tasks within an existing project you can also use
Rake tasks.

```ruby
# Rakefile

require "twitter_research/rake_task"

TwitterResearch::RakeTask.new
```

## Database Extension

MongoDB extension for record storage.

```ruby
require "twitter_research"
require "twitter_research/database"

TwitterResearch.configure!

TwitterResearch::Database::User.count
TwitterResearch::Database::Tweet.count
```

