# Use Ruby 3 base image
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs cron

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the app's code into the container
COPY . .

# Set environment variables
ENV RAILS_ENV=development

# update crontab
RUN bundle exec whenever --update-crontab

# Expose the application port
EXPOSE 3000

# Start the Rails server (use Delayed Job to handle jobs)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
