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

  def begin_round
    while mistakes <= 7 
      # play the round
      puts "Please enter a character!"
      print "Characters entered so far:"
      p choices
    end
      puts "Sorry! You're out of chances."
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

Game.new(contents).begin_round