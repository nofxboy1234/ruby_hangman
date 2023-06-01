# frozen_string_literal: true

require_relative 'game'

require 'pry-byebug'

def player_turn(game)
  game.display_info

  puts "\nYou have #{game.guesses} incorrect guesses left"
  puts 'Enter your guess (a single letter)'
  guess = gets.strip.chomp.downcase

  if game.correct_letter?(guess)
    game.update_guess_word(guess)
  else
    game.update_incorrect_guesses(guess)
    game.decrement_guesses
  end
end

def game_loop
  loop do
    game = Game.new
    game.load_dictionary
    game.select_word

    player_turn(game) until game.over?
    game.display_info
    puts "\nThe secret word was '#{game.secret_word}'"

    if game.secret_word_guessed?
      puts 'You guessed the secret word!'
    else
      puts 'Game over. You ran out of incorrect guesses!'
    end

    puts 'Play again? (y = yes / any other character = no)'
    play_again = gets.strip.chomp.downcase
    break unless play_again == 'y'
  end
end

game_loop
