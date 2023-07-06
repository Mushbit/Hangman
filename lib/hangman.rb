puts "Hangman Initialized!"

hangman = Hangman.new

class Hangman
  def initialize
    @attempts_left = 10
    @dictionary = clean_dict = clean_dictionary(File.read('google-10000-english.txt'))
    @word = pick_word(clean_dict)
    @displayed_word = Array.new(@word.length) {"_"}
    @incorrect_attempts = []
  end

  def clean_dictionary(dirty_dict)
    dirty_dict.split("\n").keep_if{|a| a.length > 4 && a.length < 13}
  end

  def pick_word(clean_dict)
    clean_dict[rand(0..clean_dict.length - 1)]
  end
end
