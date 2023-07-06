puts "Hangman Initialized!"


class Hangman
  def initialize
    @dictionary = clean_dict = clean_dictionary(File.read('google-10000-english.txt'))
    @word = pick_word(clean_dict)
    @attempts_left = 10
    @correct_attempts = Array.new(@word.length) {"_"}
    @incorrect_attempts = []
  end

  def clean_dictionary(dirty_dict)
    dirty_dict.split("\n").keep_if{|a| a.length > 4 && a.length < 13}
  end

  def pick_word(clean_dict)
    clean_dict[rand(0..clean_dict.length - 1)]
  end

  def display_game
    text =
    "    #{@attempts_left}/10 attempts left.
    Guess this word: #{@correct_attempts.join(" ")}
    incorrect letter previously tried:
    #{@incorrect_attempts.join(" ")}"
    puts text
  end


  def ask_attempt
    puts "Choose a letter:"
    char = check_attempt(gets.chomp)
  end

  def check_attempt(char)
    if @word.split('').any?(char)
      # Find index of char in @word and mofify @correct_attempts
    elsif #it corresponds with @incorrect attempts
      # Add char to @incorrect_attempts and puts "MWa MWa MWAAAAAA, try again dingwhole"
    else
      # puts "That was an incorrect guess, please try again" and subtract 1 from @attempts_left
  end
end

hangman = Hangman.new
hangman.display_game
