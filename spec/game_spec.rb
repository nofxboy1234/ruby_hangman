require './lib/game'

RSpec.describe Game do
  subject(:game) { described_class.new('dictionary_a.txt') }
  let(:text_file) { 'dictionary_b.txt' }
  let(:dictionary) { %w[cat dogs bread kittens puppies abbreviating factorizations] }

  before do
    allow(File).to receive(:readlines).and_return(dictionary)
  end

  describe '#load_text_file' do
    it 'sets the value of @text_file' do
      expect { game.load_text_file(text_file) }.to change { game.text_file }
    end
  end

  describe '#load_dictionary' do
    it 'sets the value of @dictionary' do
      expect { game.load_dictionary }.to change { game.dictionary }
    end

    it 'sends readlines message to File' do
      expect(File).to receive(:readlines)
      game.load_dictionary
    end

    context 'when the dictionary is loaded successfully from the text file' do
      it 'does not raise an error' do
        expect(game).not_to receive(:puts).with('Error while reading file dictionary_a.txt')
        game.load_dictionary
      end
    end

    context 'when rescuing an error' do
      before do
        allow(File).to receive(:readlines).and_raise(Errno::ENOENT)
        # allow(game).to receive(:puts).twice
        # allow(game).to receive(:puts).with(Errno::ENOENT)
      end

      it 'outputs two error messages' do
        expect(game).to receive(:puts).with('Error while reading file dictionary_a.txt')
        expect(game).to receive(:puts).with(Errno::ENOENT)
        game.load_dictionary
      end
    end
  end

  describe '#select_word' do
    it 'returns a random word from the dictionary' do
      game.load_dictionary
      min = 5
      max = 12

      expect(game.dictionary).to include(game.select_word(min, max))
    end

    matcher :be_between_five_and_twelve do
      match { |actual| actual.between?(5, 12) }
    end

    it 'returns a word between 5 and 12 characters long' do
      game.load_dictionary
      min = 5
      max = 12

      expect(game.select_word(min, max).length).to be_between_five_and_twelve
    end
  end
end
