class HangpersonGame
  attr_accessor :word
  attr_accessor :word_with_guesses
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letters)
    if letters == '' || /[A-Za-z]/.match?(letters) == false || letters == nil
      raise ArgumentError
    end
    if @guesses.include? letters.downcase or @wrong_guesses.include? letters.downcase
      return false
    else
      letters.each_char do |letter|
        if @word.include?(letter)
          @guesses += letter
        else
          @wrong_guesses += letter
        end
      end
    end
  end

  def word_with_guesses
    displayed = '-' * @word.length
    @guesses.each_char do |char|
      char_occurences = (0 ... @word.length).find_all { |i| @word[i, 1] == char }
      char_occurences.each do |index|
        displayed[index] = char
      end
    end
    return displayed
  end

  def check_win_or_lose
    if word_with_guesses == @word
      return :win
    elsif @guesses == ''
      return :lose
    end
    return :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
