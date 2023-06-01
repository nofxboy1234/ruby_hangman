# frozen_string_literal: true

require_relative 'game'

require 'pry-byebug'

def game_loop
  loop do
    game = Game.new
    game.play

    puts 'Play again? (y = yes / any other character = no)'
    play_again = gets.strip.chomp.downcase
    break unless play_again == 'y'
  end
end

game_loop
