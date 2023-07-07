require "pry-byebug"

puts "Hangman Initialized!"


class Hangman
  def initialize
    @dictionary = clean_dict = clean_dictionary(File.read('google-10000-english.txt'))
    @word = pick_word(clean_dict)
    @attempts_left = 10
    @correct_attempts = Array.new(@word.length) {"_"}
    @incorrect_attempts = Array.new
  end

  def clean_dictionary(dirty_dict)
    dirty_dict.split("\n").keep_if{ |a| a.length > 4 && a.length < 13 }
  end

  def pick_word(clean_dict)
    clean_dict[rand(0..clean_dict.length - 1)]
  end

  def display_game_progression
    text =
    "    #{@attempts_left}/10 attempts left.
    Guess this word: #{@correct_attempts.join(" ")}
    incorrect letter previously tried:
    #{@incorrect_attempts.join(" ")}"
    puts text
  end

  def ask_attempt
    puts "Choose a letter:"
    char = check_attempt( gets.chomp.downcase )
  end

  def check_attempt(char)
    matched_char_indexes = []

    @word.split('').each_index do |index|
      if @incorrect_attempts.any?( char ) || @correct_attempts.any?( char )
        puts "That letter has already been used"
        ask_attempt
      elsif @word[index] == char
        matched_char_indexes << index
      end
    end
    display_result(matched_char_indexes)
  end

  def display_result(display_char_indexes)
    if matched_char_indexes.any?
      puts "Nice one!"
      matched_char_indexes.each { |index| @correct_attempts[index] = char }
    else
      puts "Close, but no cigar"
      @incorrect_attempts << char
      @attempts_left -= 1
    end
    display_game_progression
    ask_attempt
  end

  def check_win
    puts "You win!" unless @correct_attempts.any?('_')
  end

  def check_loon
    puts "You lose!" unless @attempts_left <= 0
  end
end

hangman = Hangman.new
hangman.display_game_progression
hangman.ask_attempt
