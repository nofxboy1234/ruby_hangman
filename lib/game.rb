# frozen_string_literal: true

require 'yaml'

# The Game class represents a game in Hangman
class Game
  attr_reader :dictionary, :text_file, :guesses, :secret_word,
              :incorrect_guesses

  def initialize(text_file = 'google-10000-english-no-swears.txt')
    load_text_file(text_file)
    @guesses = 7
    @incorrect_guesses = []
    @correct_guesses = []
  end

  def guess_word
    @guess_word ||= Array.new(secret_word.length, '_')
  end

  def load_text_file(text_file)
    @text_file = text_file
  end

  def load_dictionary
    @dictionary = File.readlines(text_file, chomp: true)
  rescue StandardError => e
    puts "Error while reading file #{text_file}"
    puts e
  end

  def select_word(min = 5, max = 12)
    valid_words = dictionary.select { |word| word.length.between?(min, max) }
    @secret_word = valid_words.sample
  end

  def correct_letter?(guess)
    secret_word.split('').include?(guess)
  end

  def update_guess_word(guess)
    secret_word_array = secret_word.split('')
    indices = secret_word_array.each_with_index.filter_map do |letter, index|
      index if letter == guess
    end

    indices.each { |index| guess_word[index] = guess }
  end

  def decrement_guesses
    @guesses -= 1
  end

  def update_incorrect_guesses(guess)
    @incorrect_guesses << guess
  end

  def over?
    secret_word_guessed? || no_more_guesses_left?
  end

  def no_more_guesses_left?
    guesses.zero?
  end

  def secret_word_guessed?
    guess_word.join == secret_word
  end

  def display_info
    system 'clear'
    p secret_word
    p guess_word
    puts "incorrect guesses: #{incorrect_guesses}"
  end

  def player_turn
    display_info
  
    puts "\nYou have #{guesses} incorrect guesses left"
    puts 'Enter your guess (a single letter)'
    guess = gets.strip.chomp.downcase
  
    if correct_letter?(guess)
      update_guess_word(guess)
    else
      update_incorrect_guesses(guess)
      decrement_guesses
    end
  end

  def play
    load_dictionary
    select_word
  end
end
