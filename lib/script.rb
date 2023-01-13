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

  def check_input(input, confirmation)
    unless answer.include?(input)
      p confirmation
      if confirmation 
        self.mistakes += 1
      end
    end
    puts "mistakes: #{mistakes}"
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

      unless choices.include?(input)
        choices.push(input)
        return [choices[-1], true] #"true" meaning that this has to go thru `check_input`
      end
      [choices[-1], false]
  end

  def display_puzzle
    print "Guess the word: "
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

  def final_message
    if mistakes >= 7 
      puts "Sorry! You're out of chances! :("
    else
      puts "Congrats! You guessed the word!"
    end
  end

  def begin_game
    puts "Welcome to the Hangman game! You have 7 lives to guess the word!"
    while mistakes < 7 
      puts draw_hangman(mistakes)
      display_puzzle
      input_array = seek_input
      check_input(input_array[0], input_array[1])
      sleep(1.2)
      puts "\e[H\e[2J"
      break if end_game?
    end
    puts draw_hangman(mistakes)
    final_message
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