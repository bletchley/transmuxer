# Transmuxer

A library for converting videos into HLS format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transmuxer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transmuxer

## Usage

### Generate Migration

To set up transmuxing for Medium model, run the following:

```ruby
rails generate transmuxer media
```

### Configuration

#### Notifications Host

```ruby
Transmuxer.config do |c|
  c.notifications_host = "NOTIFICATIONS_HOST"
end
```

#### Zencoder

```ruby
Transmuxer.config do |c|
  c.zencoder.api_key = "ZENCODER_API_KEY"
end
```

### S3

```ruby
Transmuxer.config do |c|
  c.s3.bucket_name = "S3_BUCKET_NAME"
end
```
### Add to AR model

```ruby
class Medium < ActiveRecord::Base
  include Transmuxer::Transmuxable
  transmuxable :original_url

  def original_url
    "PUBLICLY_ACCESSIBLE_URL"
  end
end
```

### Start Transmuxing

```ruby
m = Medium.first
m.transmux
```

### Restart Transmuxing

```ruby
m = Medium.first
m.transmux_retry
```

### Check Transmuxing Progress

```ruby
m = Medium.first
m.transmux_progress
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/transmuxer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
