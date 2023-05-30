# frozen_string_literal: true

require 'yaml'
require 'pry-byebug'

# The Game class represents a game in Hangman
class Game
  attr_reader :dictionary, :text_file, :guesses, :secret_word, :guess_word

  def initialize(text_file = 'google-10000-english-no-swears.txt')
    load_text_file(text_file)
    @guesses = 7
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
    secret_word.include?(guess)
  end

  def update_guess_word(guess, indices)
    @guess_word = guess_word.each_with_index.map do |char, index|
      indices.include?(index) ? guess : char
    end
  end

  def indices_of_letter(guess)
    secret_word_array = secret_word.split('')
    secret_word_array.each_with_index.filter_map do |letter, index|
      index if letter == guess
    end
  end

  def decrement_guesses
    @guesses -= 1
  end
end
