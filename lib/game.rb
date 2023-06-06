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

  def save
    Dir.mkdir 'save' unless Dir.exist? 'save'
    File.open('save_file', 'w') do |file|
      file.write(to_yaml)
    end
  end

  def self.load
    YAML.safe_load(read_yaml_from_file)
  end

  def self.read_yaml_from_file
    File.open('save_file', 'r') do |file|
      file.read
    end
  end

  def to_yaml
    YAML.dump(data_to_save)
  end

  private

  def data_to_save
    {
      secret_word: secret_word,
      guess_count: guess_count,
      dictionary: dictionary,
      incorrect_guesses: incorrect_guesses,
      guess_word: guess_word
    }
  end

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
