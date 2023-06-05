# frozen_string_literal: true

# The Dictionary class is responsible for loading a text file and its words
class Dictionary
  attr_reader :text_file, :words

  def initialize(text_file)
    @text_file = text_file
  end

  def load_text_file
    @words = File.readlines(text_file, chomp: true)
  rescue StandardError => e
    puts "Error while reading file #{text_file}"
    puts e
  end

  def valid_words(min = 5, max = 12)
    words.select { |word| word.length.between?(min, max) }
  end
end
