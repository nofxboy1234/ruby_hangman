# frozen_string_literal: true

require_relative 'game'

game = Game.new
game.load_dictionary
game.select_word

p game.secret_word
p Array.new(game.secret_word.length, '_')

puts 'Enter your guess'
guess = gets.strip.chomp.downcase
indices = game.indices_of_letter(guess)

game.update_guess_word(guess, indices) if game.correct_letter?(guess)

p game.guess_word
