# frozen_string_literal: true

require 'yaml'

# The Game class represents a game in Hangman
class Game
  attr_reader :dictionary

  def initialize; end

  def load_dictionary(text_file)
    @dictionary = File.readlines(text_file, chomp: true)
  rescue StandardError => e
    puts "Error while reading file #{text_file}"
    puts e
  end
end
