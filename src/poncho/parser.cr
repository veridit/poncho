module Poncho
  # `Poncho::Parser` is a .env file parser
  #
  # ### Parse file
  #
  # ```
  # parser = Poncho::Parser.from_file(".env")
  # parser["ENV"] # => "development"
  # ```
  #
  # ### Parse raw string
  #
  # ```
  # parser = Poncho::Parser.new("ENV=development\nDB_NAME=poncho\nENV=production")
  # parser.parse
  # parser["ENV"] # => "development"
  #
  # # Overwrite the key
  # parser.parse!
  # parser["ENV"] # => "production"
  #
  class Parser
    def self.from_file(file : String, overwrite = false)
      parser = new(File.open(file))
      parser.parse(overwrite)
      parser
    end

    @env = {} of String => String

    def initialize(@raw : String | IO)
    end

    # Parse environment variables and overwrite existing ones.
    #
    # Same as `#parse`(overwrite: true)
    def parse!
      parse(true)
    end

    # Parse environment variables
    def parse(overwrite = false)
      @raw.each_line do |line|
        next if line.blank? || !line.includes?('=')
        next unless expression = extract_expression(line)

        key, value = expression.split("=", 2).map { |v| v.strip }
        if ['\'', '"'].includes?(value[0]) && ['\'', '"'].includes?(value[-1])
          if value[0] == '"' && value[-1] == '"'
            value = value.gsub("\\n", "\n").gsub("\\r", "\r")
          end

          value = value[1..-2]
        end

        env_key = format_env_for(key)
        key_existes = @env.has_key?(env_key)
        @env[env_key] = value.rstrip if !key_existes || (key_existes && overwrite)
      end

      nil
    end

    # Returns this collection as a plain Hash.
    def to_h : Hash(String, String)
      @env
    end

    forward_missing_to @env

    private def format_env_for(key : String)
      lower = false
      key.each_codepoint do |codepoint|
        lower = true if codepoint >= 97 && codepoint <= 122
      end

      key = snakecase(key) if lower
      key.upcase
    end

    private def extract_expression(raw)
      if raw.includes?('#')
        segments = [] of String
        quotes_open = false
        raw.split('#').each do |segment|
          if segment.scan("'").size == 1 || segment.scan("\"").size == 1
            if quotes_open
              quotes_open = false
              segments << segment
            else
              quotes_open = true
            end
          end

          if segments.size.zero? || quotes_open
            segments << segment
          end
        end

        line = segments.join('#')
        line unless line.empty?
      else
        raw
      end
    end

    private def snakecase(key : String) : String
      return key if key.empty?

      first = true
      String.build do |io|
        key.each_char do |char|
          if first
            io << char.downcase
          elsif char.ord >= 65 && char.ord <= 90
            io << '_' << char.downcase
          else
            io << char
          end

          first = false
        end
      end
    end
  end
end
