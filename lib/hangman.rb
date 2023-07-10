require "pry-byebug"

puts "Hangman Initialized!"

def run
puts "Press enter to play"
gets
# puts "Would you like to continue where you left off? Y/n"
# answer = gets.chomp.downcase
# if answer == "y"
#   Hangman.new(File.open("save.txt", r))
#   hangman.display_game_progression
#   hangman.ask_attempt
# else
hangman = Hangman.new
hangman.display_game_progression
hangman.ask_attempt
# end
end

def reset
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
    display_result(matched_char_indexes, char)
  end

  def display_result(matched_char_indexes, char)
    if matched_char_indexes.any?
      matched_char_indexes.each { |index| @correct_attempts[index] = char }
    else
      @incorrect_attempts << char
      @attempts_left -= 1
    end
    display_game_progression
    ask_attempt unless check_win_condition
  end

  def check_win_condition
    if @correct_attempts.none?('_')
      puts "You win!"
      reset
      true
    elsif@attempts_left <= 0
      puts "You lose!"
      reset
      true
    end
  end
end

run
