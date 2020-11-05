FROM jruby:9.2.13.0-jdk8 as builder
WORKDIR /app
COPY . .
RUN bundle install
RUN bundle exec rspec
FROM logstash:7.9.3
COPY --from=builder /app ./logstash-output-file
RUN sed -i '/logstash-output-file/d' Gemfile && echo 'gem "logstash-output-file", :path => "./logstash-output-file"' >> Gemfile
RUN bin/logstash-plugin install --no-verify
