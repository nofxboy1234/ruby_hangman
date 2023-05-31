# frozen_string_literal: true

require 'yaml'

# The Game class represents a game in Hangman
class Game
  attr_reader :dictionary, :text_file, :guesses, :secret_word, :guess_word,
              :incorrect_guesses, :correct_guesses

  def initialize(text_file = 'google-10000-english-no-swears.txt')
    load_text_file(text_file)
    @guesses = 7
    @incorrect_guesses = []
    @correct_guesses = []
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

  def update_guess_word
    updated_guess_word = Array.new(secret_word.length, '_')

    all_correct_guess_indices.each_pair do |guess, indices|
      indices.each do |index|
        updated_guess_word[index] = guess
      end
    end

    @guess_word = updated_guess_word
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

  def update_correct_guesses(guess)
    @correct_guesses << guess
  end

  def no_more_guesses_left?
    guesses.zero?
  end

  def secret_word_guessed?
    guess_word.join == secret_word
  end

  private

  def indices_of_letter(guess)
    secret_word_array = secret_word.split('')
    secret_word_array.each_with_index.filter_map do |letter, index|
      index if letter == guess
    end
  end

  def all_correct_guess_indices
    correct_guesses.map { |guess| [guess, indices_of_letter(guess)] }.to_h
  end
end
