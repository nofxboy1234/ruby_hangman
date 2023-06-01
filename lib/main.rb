# frozen_string_literal: true

require_relative 'game'

require 'pry-byebug'

def prompt_for_play_again
  puts 'Play again? (y = yes / any other character = no)'
  gets.strip.chomp.downcase
end

def dictionary
  text_file = 'google-10000-english-no-swears.txt'
  Dictionary.new(text_file)
end

def game_loop
  loop do
    game = Game.new(dictionary)
    game.play

    play_again = prompt_for_play_again
    break unless play_again == 'y'
  end
end

game_loop
