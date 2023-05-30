# frozen_string_literal: true

require_relative 'game'

def player_turn(game)
  puts 'Enter your guess'
  guess = gets.strip.chomp.downcase
  indices = game.indices_of_letter(guess)

  game.update_incorrect_guesses(guess) unless game.correct_letter?(guess)
  game.update_guess_word(guess, indices)

  game.decrement_guesses
  puts "You have #{game.guesses} guesses left"

  p game.guess_word
end

game = Game.new
game.load_dictionary
game.select_word

p game.secret_word
p Array.new(game.secret_word.length, '_')

player_turn(game)
