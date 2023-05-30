# frozen_string_literal: true

require_relative 'game'

game = Game.new
game.load_dictionary
game.select_word

puts Array.new(game.secret_word.length, '_')

puts 'Enter your guess'
guess = gets.strip.chomp.downcase

if game.correct_letter?(guess)
  game.update_guess_word
end

puts Array.new(game.secret_word.length, '_')




