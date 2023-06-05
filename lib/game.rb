# frozen_string_literal: true

require_relative 'display'
require 'yaml'

require 'pry-byebug'

# The Game class represents a game in Hangman
class Game
  include Display
  attr_reader :secret_word, :guess_count

  private

  attr_reader :dictionary, :incorrect_guesses

  public

  def initialize(dictionary)
    @guess_count = 7
    @incorrect_guesses = []
    @dictionary = dictionary
  end

  def over?
    secret_word_guessed? || no_more_guesses_left?
  end

  def update_state(guess)
    if correct_letter?(guess)
      update_guess_word(guess)
    else
      update_incorrect_guesses(guess)
      decrement_guesses
    end
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

  def update_incorrect_guesses(guess)
    incorrect_guesses << guess
  end

  def decrement_guesses
    @guess_count -= 1
  end

  def select_word
    @secret_word = dictionary.valid_words.sample
  end

  def to_yaml
    YAML.dump({
                secret_word: @secret_word,
                guess_count: @guess_count,
                dictionary: @dictionary,
                incorrect_guesses: @incorrect_guesses,
                guess_word: @guess_word
              })
  end

  def write_yaml_to_file
    File.open('save_file', 'w') do |somefile|
      somefile.write(to_yaml)
    end
  end

  def self.from_yaml(yaml_string)
    YAML.load(yaml_string)
  end

  private

  def guess_word
    @guess_word ||= Array.new(secret_word.length, '_')
  end

  def secret_word_guessed?
    guess_word.join == secret_word
  end

  def no_more_guesses_left?
    guess_count.zero?
  end
end
