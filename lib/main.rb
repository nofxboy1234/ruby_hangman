# frozen_string_literal: true

require_relative 'game'

def player_turn(game)
  puts 'Enter your guess'
  guess = gets.strip.chomp.downcase
  indices = game.indices_of_letter(guess)

  unless game.correct_letter?(guess)
    game.update_incorrect_guesses(guess)
    game.decrement_guesses
  end

  game.update_guess_word(guess, indices)

  puts "You have #{game.guesses} guesses left"

  p game.guess_word
end

game = Game.new
game.load_dictionary
game.select_word
game.update_guess_word

p game.secret_word
p Array.new(game.secret_word.length, '_')

player_turn(game) until game.over?
