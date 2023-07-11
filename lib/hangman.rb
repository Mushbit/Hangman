require "pry-byebug"
require "json"

puts "Hangman Initialized!"

class Game
  def self.run
    puts "Would you like to continue where you left off? Y/n"
    answer = gets.chomp.downcase
    if answer == "y"
      binding.pry
      Hangman.new(JSON.load("hangman_save.json"))
      hangman.display_game_progression
      hangman.ask_attempt
    else
      hangman = Hangman.new
      hangman.display_game_progression
      hangman.ask_attempt
    end
  end

  def self.reset
    puts 'Want to play again? Y/n'
    answer = gets.chomp.downcase
    if answer == 'y'
      hangman = Hangman.new
      hangman.display_game_progression
      hangman.ask_attempt
    else
      puts 'Type: "run" if you change your mind.'
    end
  end
end


class Hangman
  def initialize
    @dictionary = clean_dictionary(File.read('google-10000-english.txt'))
    @word = pick_word(clean_dict)
    @attempts_left = 10
    @correct_attempts = Array.new(@word.length) {"_"}
    @incorrect_attempts = Array.new
  end

  def to_json
    JSON.dump ({
      :dictionary => @dictionary,
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
    char = check_attempt_validity( gets.chomp.downcase )
  end

  def check_attempt_validity(char)
    matched_char_indexes = []

    @word.split('').each_index do |index|
      if char.match?(/^[a-z]$/)
        if @incorrect_attempts.any?( char ) || @correct_attempts.any?( char )
          puts "That letter has already been used"
          ask_attempt
        elsif @word[index] == char
          matched_char_indexes << index
        end
      else
        puts "The input may only consist of a single letter, please try again"
        ask_attempt
      end
    end
    update_game_state(matched_char_indexes, char)
  end

  def update_game_state(matched_char_indexes, char)
    if matched_char_indexes.any?
      matched_char_indexes.each { |index| @correct_attempts[index] = char }
    else
      @incorrect_attempts << char
      @attempts_left -= 1
    end
    save_game
    display_game_progression
    ask_attempt unless check_win_condition
  end

  def check_win_condition
    if @correct_attempts.none?('_')
      puts "You win!"
      Game.reset
      true
    elsif@attempts_left <= 0
      puts "You lose!"
      Game.reset
      true
    end
  end
end

Game.run
