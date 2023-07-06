puts "Hangman Initialized!"

def clean_dictionary(dictionary)
  puts dictionary.split("\n").keep_if{|a| a.length == 5..12}
end
clean_dictionary(File.read ('google-10000-english.txt'))
