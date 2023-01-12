def select_word(words)
  word = words[rand(words.length - 1)].chomp
  until word.length.between?(5,12)
    word = words[rand(words.length - 1)].chomp    
  end
  word
end

contents = File.readlines("./google-10000-english-no-swears.txt")

#The game has started. Choose a random word between 5-12 characters.
p select_word(contents)