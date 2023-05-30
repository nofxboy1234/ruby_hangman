# frozen_string_literal: true

require 'yaml'

require 'pry-byebug'

# The Game class represents a game in Hangman
class Game
  attr_reader :dictionary, :text_file

  def initialize(text_file = 'google-10000-english-no-swears.txt')
    load_text_file(text_file)
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

  def select_word(min, max)
    valid_words = dictionary.select { |word| word.length.between?(min, max) }
    valid_words.sample
  end
end
