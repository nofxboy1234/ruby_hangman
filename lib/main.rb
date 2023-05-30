# frozen_string_literal: true

require_relative 'game'

game = Game.new
game.load_dictionary
game.select_word

puts 'Enter your guess'
guess = gets.strip.chomp.downcase
game.correct_letter?(guess)


