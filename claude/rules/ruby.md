---
description: Ruby/Rails conventions for rspec, rubocop, and rbenv
globs:
  - "**/*.rb"
  - "Gemfile"
  - "*.gemspec"
  - "Rakefile"
---

# Ruby Conventions

- Run rspec: `bundle exec rspec path/to/spec`
- If encountering Ruby version issues, try `rbenv exec`
- Do not use unnecessary arguments when factory has default values in rspec
