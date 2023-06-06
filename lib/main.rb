# frozen_string_literal: true

require_relative 'game'
require_relative 'dictionary'

require 'pry-byebug'

def prompt_for_play_again
  puts 'Play again? (y = yes / any other character = no)'
  gets.strip.chomp.downcase
end

def dictionary
  text_file = 'google-10000-english-no-swears.txt'
  @dictionary ||= Dictionary.new(text_file)
end

def prompt_for_save
  puts "Save your progress? (y = yes / any other character = no)"
  gets.strip.chomp.downcase
end

def display_progress
  game.display_info
  puts "\nYou have #{game.guess_count} incorrect guesses left"  
end

def player_turn
  display_progress

  prompt_for_save
  system 'clear'
  
  display_progress

  puts 'Enter your guess (a single letter)'
  guess = gets.strip.chomp.downcase
  
  game.update_state(guess)
end

def set_up
  dictionary.load_text_file
  game.select_word
end

def play
  set_up
  player_turn until game.over?
  game.display_info
  puts "\nThe secret word was '#{game.secret_word}'"
  game.end_message
end

def game
  @game
end

def game_loop
  loop do
    @game = Game.new(dictionary)
    play

    play_again = prompt_for_play_again
    break unless play_again == 'y'
  end
end

game_loop
