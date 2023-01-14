require 'yaml'

module Input
  def ask_user_input(valid_options)
    input = gets.chomp.downcase
    until valid_options.include?(input)
      puts "Please choose an option from: #{valid_options}"
      input = gets.chomp.downcase
    end
    input
  end
end

class Decider include Input
  
  def initialize
    puts "Welcome to the Hangman game! Please press 'p' to play a new game and 'x' to load a previous game."
    decide
  end

  def new_game
    puts "\e[H\e[2J"
    contents = File.readlines("./google-10000-english-no-swears.txt").map{|word| word.chomp}
    Game.new(contents).begin_game
  end

  def retrieve_files
    files = Dir["./saved_games/*"]
    files.each_with_index{|file, index| puts "#{index+1}. #{file.partition("/").last.partition("/").last}"}
    files
  end

  def load_game
    if Dir.exist?("saved_games")
      #TODO: implement a feature that lets you load from a list of previous games.
      puts "Please select the game you want to load and play!"
      files = retrieve_files
      options = []
      for i in 1..files.size do options.push(i.to_s) end
      input = ask_user_input(options)
      (Marshal.load(File.read("#{files[input.to_i-1]}")).begin_game)
    else
      puts "No saved games found. Please enter 'p' to start a new game or 'q' to quit the program."
      input = ask_user_input([].push('p').push('q'))
      new_game if input == 'p'
      puts "Goodbye! :)" if input == 'q'
    end
  end

  def decide
    initial_input = ask_user_input([].push('p').push('x')) #'p' and 'x' are the valid options
    case initial_input
    when 'p' then new_game
    when 'x' then load_game 
    end
  end
end

class Game include Input
  private attr_accessor :mistakes, :choices
  private attr_reader :answer
  attr_reader :words
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
    word
  end

  def check_input(input, confirmation)
    unless answer.include?(input)
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

  #Returns true if the user wants to save the game; false otherwise.
  def save_or_continue
    puts "Press 's' if you want to 'S'ave the game and 'c' if you want to 'C'ontinue."
    input = ask_user_input([].push('s').push('c'))
    puts "\e[H\e[2J"
    input == 's'
  end 

  def save_game
    file_name = Time.now
    if Dir.exist?("./saved_games")
      File.open("./saved_games/#{file_name}", 'wb') { |f| f.write(Marshal.dump(self)) }
    else 
      Dir.mkdir("./saved_games")
      File.open("./saved_games/#{file_name}", 'wb') { |f| f.write(Marshal.dump(self)) }
    end
    puts "Your game has now been saved as #{file_name}!"
  end

  def begin_game
    puts "Welcome to the Hangman game! You have #{7-mistakes} lives to guess the word!"
    while mistakes < 7 
      puts draw_hangman(mistakes)
      display_puzzle
      break if save_or_continue
      puts draw_hangman(mistakes)
      display_puzzle
      input_array = seek_input
      check_input(input_array[0], input_array[1])
      puts "\e[H\e[2J"
      break if end_game?
    end

    if end_game?
      puts draw_hangman(mistakes)
      final_message
    else
      save_game  
    end
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

Decider.new