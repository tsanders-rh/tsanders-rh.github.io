FROM docker.io/ruby:3.2

WORKDIR /app

# Install dependencies
COPY Gemfile* ./
RUN bundle install

# Copy the rest of the app
COPY . .

# Expose port 4000
EXPOSE 4000

# Run Jekyll server
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--drafts", "--livereload"]
