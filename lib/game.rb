# frozen_string_literal: true

require_relative 'display'
require_relative 'dictionary'
require 'yaml'

require 'pry-byebug'

# The Game class represents a game in Hangman
class Game
  include Display
  attr_reader :dictionary, :secret_word, :incorrect_guesses, :guess_count

  def initialize(dictionary)
    @guess_count = 7
    @incorrect_guesses = []
    @dictionary = dictionary
  end

  def over?
    secret_word_guessed? || no_more_guesses_left?
  end

  def player_turn
    display_info

    puts "\nYou have #{guess_count} incorrect guesses left"
    puts 'Enter your guess (a single letter)'
    guess = gets.strip.chomp.downcase

    update_state(guess)
  end

  def set_up
    dictionary.load_text_file
    select_word
  end

  def play
    set_up
    player_turn until over?
    display_info
    puts "\nThe secret word was '#{secret_word}'"
    end_message
  end

  def guess_word
    @guess_word ||= Array.new(secret_word.length, '_')
  end

  private

  def update_state(guess)
    if correct_letter?(guess)
      update_guess_word(guess)
    else
      update_incorrect_guesses(guess)
      decrement_guesses
    end
  end

  def secret_word_guessed?
    guess_word.join == secret_word
  end

  def no_more_guesses_left?
    guess_count.zero?
  end

  def update_incorrect_guesses(guess)
    incorrect_guesses << guess
  end
  
  def decrement_guesses
    @guess_count -= 1
  end

  def update_guess_word(guess)
    secret_word_array = secret_word.split('')
    indices = secret_word_array.each_with_index.filter_map do |letter, index|
      index if letter == guess
    end
    indices.each { |index| guess_word[index] = guess }
  end

  def correct_letter?(guess)
    secret_word.split('').include?(guess)
  end

  def select_word
    @secret_word = dictionary.valid_words.sample
  end
end
