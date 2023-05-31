# frozen_string_literal: true

require_relative 'game'

def player_turn(game)
  system 'clear'
  p game.secret_word

  p game.guess_word

  p game.incorrect_guesses
  puts "You have #{game.guesses} incorrect guesses left"
  puts 'Enter your guess'
  guess = gets.strip.chomp.downcase

  if game.correct_letter?(guess)
    game.update_correct_guesses(guess)
  else
    game.update_incorrect_guesses(guess)
    game.decrement_guesses
  end

  game.update_guess_word
end

game = Game.new
game.load_dictionary
game.select_word
game.update_guess_word

player_turn(game) until game.over?

if game.secret_word_guessed?
  puts 'You guessed the secret word!'
else
  puts 'Game over. You ran out of incorrect guesses!'
end
