# GrapeLogFormatter

Provide log formatter for Grape API. Logged data now contains PID, Time, Path, Params and user IP.


## Example
```bash
[2016-07-01 15:31:42 +0200] INFO -- POST 200  /api/v1/publish_product_review
Params: {"lead_content_id":"4266a24e-ec1e-4818-9c09-ceb269c693a3","content_type":"product_reviews"}
PID: 30896 | IP: 127.0.0.1 | Total: 4.28 DB: 0.0 View: 4.28
```

## Installation
This gem is mostly used in compbination with ```grape_logging``` so if you will do it same, then add this lines to your application's Gemfile:

```ruby
gem "grape_logging"
gem "grape_log_formatter"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape_log_formatter

## Usage

In your API class use the logging middeware and pass GrapeLogFormatter .

```ruby
class API < Grape::API
  use GrapeLogging::Middleware::RequestLogger,
    logger: logger,
    include: [ GrapeLogging::Loggers::ClientEnv.new],
    formatter: GrapeLogFormatter::Basic.new
end
```

### Logging exceptions

```ruby
# Pass env variable to the logger so the logger has request data accessible
rescue_from Grape::Exceptions::ValidationErrors do |err|
  API.logger.info(exception: err, tags: "rescued_exception", env: env)
  error_response(message: err.message, status: 400)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reevoo/grape_log_formatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
