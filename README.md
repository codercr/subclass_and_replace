# Subclass and Replace

Create a new class which inherits from a class it will replace.

# Description

Use this class when you need to replace a class method and still call the superclass method.

## Documentation

### Install

    gem install subclass_and_replace

### Example

Set defaults to Rails cookies without writing custom methods or changing core code.

```ruby
subclass_and_replace ActionDispatch::Cookies::CookieJar do

  def handle_options(options)
    options[:httponly] = true if options[:httponly].nil?
  end

end
```
