![poncho-logo](https://github.com/icyleaf/poncho/raw/master/logo-small.png)

# Poncho

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/poncho.svg)](https://github.com/icyleaf/poncho/blob/master/CHANGELOG.md)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/poncho/master.svg?style=flat)](https://circleci.com/gh/icyleaf/poncho)

A .env parser/loader improved for performance. Poncho Icon by lastspark from <a href="https://thenounproject.com">Noun Project</a>.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  poncho:
    github: icyleaf/poncho
```

## Usage

```crystal
require "poncho"
```

## Parse dotenv

```
poncho = Poncho.from_file ".env"
# or
poncho = Poncho.parse "PONCHO_ENV=development"

poncho["PONCHO_ENV"] # => "development"
```

## Contributing

1. Fork it (<https://github.com/icyleaf/poncho/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) icyleaf - creator, maintainer
