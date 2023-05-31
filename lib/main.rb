# frozen_string_literal: true

require_relative 'game'

require 'pry-byebug'

def display_info(game)
  system 'clear'
  p game.guess_word
  puts "incorrect guesses: #{game.incorrect_guesses}"  
end

def player_turn(game)
  display_info(game)

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

def game_loop
  loop do
    game = Game.new
    game.load_dictionary
    game.select_word
    game.update_guess_word
    
    player_turn(game) until game.over?
    display_info(game)
    puts "The secret word was '#{game.secret_word}'"


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
