# frozen_string_literal: true

require_relative 'game'

game = Game.new
game.load_dictionary('google-10000-english-no-swears.txt')
