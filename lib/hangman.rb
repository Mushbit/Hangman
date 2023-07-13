require "pry-byebug"
require "json"

puts "Hangman Initialized!"

class Game
  attr_accessor :hangman
  def initialize
    @hangman = Hangman.new
    launch
  end

  def launch
    puts "Would you like to continue where you left off? Y/n"
    answer = gets.chomp.downcase
    if answer == "y"
      save_file = JSON.load(File.read('hangman_save.json'))
      hangman.load_game(save_file)
      # have Hangman class accept arguments OR create a self initializing method within the class...interesting!
    end
    run
  end

  def run
    hangman.display_game_progression

    until hangman.check_game_over_condition do
      hangman.save_game

      char = hangman.ask_attempt
      binding.pry
      # working on it right here
      matched_char_indexes = hangman.check_attempt_validity(char) unless hangman.check_attempt_validity(char)
      hangman.update_game_state(matched_char_indexes, char)
      hangman.display_game_progression
    end

    reset
  end

  def reset
    puts 'Want to play again? Y/n'
    answer = gets.chomp.downcase
    if answer == 'y'
      @hangman = Hangman.new
      run
    else
      puts 'Type: "run" if you change your mind.'
    end
  end
end


class Hangman
  def initialize
    @word = pick_word(clean_dictionary(File.read('google-10000-english.txt')))
    @attempts_left = 10
    @correct_attempts = Array.new(@word.length) {"_"}
    @incorrect_attempts = Array.new
  end

  def to_json
    JSON.dump ({
      :word => @word,
      :attempts_left => @attempts_left,
      :correct_attempts => @correct_attempts,
      :incorrect_attempts => @incorrect_attempts
    })
  end

  def save_game
    Dir.mkdir('output') unless Dir.exists?('output')
    filename = 'hangman_save.json'
    File.open(filename, 'w') do |file|
      file.puts to_json
    end
  end

  def load_game(save_file)
    @word = save_file['word']
    @attempts_left = save_file['attempts_left']
    @correct_attempts = save_file['correct_attempts']
    @incorrect_attempts = save_file['incorrect_attempts']
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
    gets.chomp.downcase
  end

  # Returns false upon failure.
  def check_attempt_validity(char)
    matched_char_indexes = []
    @word.split('').each_index do |index|
      if char.match?(/^[a-z]$/)
        if @incorrect_attempts.any?( char ) || @correct_attempts.any?( char )
          puts "That letter has already been used, please try again"
          return false
        elsif @word[index] == char
          matched_char_indexes << index
        end
      else
        puts "The input may only consist of a single letter, please try again"
        return false
      end
    end
    matched_char_indexes
  end

  def update_game_state(matched_char_indexes, char)
    if matched_char_indexes.any?

      matched_char_indexes.each { |index| @correct_attempts[index] = char }
    else
      @incorrect_attempts << char
      @attempts_left -= 1
    end
  end

  def check_game_over_condition
    if @correct_attempts.none?('_')
      puts "\n --- You win! --- \n"
      true
    elsif@attempts_left <= 0
      puts "\n --- You lose! --- \n"
      true
    end
  end
end

game = Game.new
