# tokenizer.rb

require_relative 'data.rb'

class Tokenizer
  attr_accessor :tokens

  def initialize(text)
    @chars = text.chars.reverse
    @tokens = []
    @position = Position.new
  end

  def read
    read_start next_char
  end

  def read_start(a)
    case
    when a == nil
      return
    when a.numeric?
      read_number a
    when a.alpha?
      read_ident a
    when ' \t'.include?(a)
      read
    else
      read_punct a
    end
  end

  def read_number(a)
    tok, a = read_characters a, :numeric?
    if a == '.'
      decimal, a = read_characters a, :numeric?
      token tok + decimal
    else
      token tok
    end
    read_start a
  end

  def read_ident(a)
    tok, a = read_characters a, :alphanumeric?
    token tok
    read_start a
  end

  def read_characters(a, method)
    ident = [a]
    while (a = next_char) and a.send method
      ident << a
    end
    return ident.join(''), a
  end

  def read_punct(a)
    token (CHAR_MAPPING[a] || a)
    read
  end

  def token(a)
    unless a.is_a? Symbol
      a = a.to_sym
    end
    @tokens << Token.new(a, @position) # This might need a clone
  end

  def next_char
    a = @chars.pop
    @position.increment(a)
    a
  end
  
end

