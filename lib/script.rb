class Game
  private attr_accessor :mistakes, :choices
  private attr_reader :answer
  def initialize(words)
    @words = words    
    @answer = select_word(words)
    @mistakes = 0
    @choices = []
    draw_hangman(mistakes)
  end

  def select_word(words)
    word = words[rand(words.length - 1)]
    until word.length.between?(5,12)
      word = words[rand(words.length - 1)]  
    end
    p word
  end

  def check_input(input)
    
    unless answer.include?(input)
      begin 
      self.mistakes += 1
      puts "mistakes: #{mistakes}"
      rescue => exception
        puts exception
      end
    end
  end

  def clean_input(input)
    unless input == ""
      input = input[0]
    else
      input
    end
  end

  def seek_input
    puts "Please enter a character\nCharacters entered so far:\n"
      p choices
      puts "Waiting for input..."
      
      input = clean_input(gets.chomp)

      until input.match?(/[[:alpha:]]/)
        input = input.downcase
        if choices.include?(input)
          next
        else
        #keep asking for input.
        puts "Please enter a valid character.\nCharacters entered so far:\n"
        p choices
        puts "Waiting for input..." 
        input = gets.chomp    
        end    
      end

      choices.push(input) unless choices.include?(input)
      input
  end

  def display_puzzle
    print "The word is "
    word_array = answer.split("")
    word_array.each do |char| 
      if choices.include?(char)
        print "#{char} "
      else 
        print "_ " 
      end
    end
    puts "\n\n=================== \n\n"
  end

  def end_game?
    word_array = answer.split("")
    unguessed = []
    word_array.each do |char|
      unless choices.include?(char)
        unguessed.push("e")
      end
    end
    mistakes >= 7 || unguessed.size == 0
  end

  def begin_game
    while mistakes <= 7 
      display_puzzle
      draw_hangman(mistakes)
      input = seek_input
      check_input(input)
      break if end_game?
    end
      puts "Sorry! You're out of chances." if mistakes >= 7
      puts "Congrats! You guessed the word!"
  end

  def draw_hangman(index)
    arr = [%{    +---+
        |
        |
        |
        |
        |
      =====}, %{    +---+
    |   |   
        |
        |
        |
        |
      =====}, %{      +---+
      |   |
      O   |
          |
          |
          |
    =========}, %{      +---+
      |   |
      O   |
      |   |
          |
          |
    =========}, %{      +---+
      |   |
      O   |
     /|   |
          |
          |
    =========}, %q{      +---+
      |   |
      O   |
     /|\  |
          |
          |
    =========}, %q{      +---+
      |   |
      O   |
     /|\  |
     /    |
          |
    =========}, %q{      +---+
      |   |
      O   |
     /|\  |
     / \  |
          |
    =========}]
    arr[index]
  end

end

contents = File.readlines("./google-10000-english-no-swears.txt").map{|word| word.chomp}

Game.new(contents).begin_game