require './lib/game'

RSpec.describe Game do
  subject(:game) { described_class.new('dictionary.txt') }
  let(:text_file) { 'dictionary2.txt' }

  before do
    allow(File).to receive(:readlines).and_return(%w[a b c])
  end

  describe '#load_text_file' do
    it 'sets the value of @text_file' do
      expect { game.load_text_file(text_file) }.to change { game.text_file }
    end
  end
  
  describe '#load_dictionary' do

    it 'sets the value of @dictionary' do
      expect { game.load_dictionary }.to change { game.dictionary }
        .from(nil).to(%w[a b c])
    end

    it 'sends readlines message to File' do
      expect(File).to receive(:readlines)
      game.load_dictionary
    end

    context 'when the dictionary is loaded successfully from the text file' do
      it 'does not raise an error' do
        expect(game).not_to receive(:puts).with('Error while reading file dictionary.txt')
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
        expect(game).to receive(:puts).with('Error while reading file dictionary.txt')
        expect(game).to receive(:puts).with(Errno::ENOENT)
        game.load_dictionary
      end
    end
  end

  describe '#select_word' do
    it 'returns a random word from the dictionary' do
      game.load_dictionary

      expect(game.dictionary).to include(game.select_word)
    end
  end
end
