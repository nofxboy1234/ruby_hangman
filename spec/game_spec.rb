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
      end

      it 'outputs two error messages' do
        expect(game).to receive(:puts).with('Error while reading file dictionary_a.txt')
        expect(game).to receive(:puts).with(Errno::ENOENT)
        game.load_dictionary
      end
    end
  end

  describe '#select_word' do
    let(:min) { 5 }
    let(:max) { 12 }

    before do
      game.load_dictionary
      game.select_word(min, max)
    end

    it 'sets @secret_word to a random word from the dictionary' do
      expect(game.dictionary).to include(game.secret_word)
    end

    matcher :be_between_five_and_twelve do
      match { |actual| actual.between?(5, 12) }
    end

    it 'sets @secret_word to a word between 5 and 12 characters long' do
      expect(game.secret_word.length).to be_between_five_and_twelve
    end
  end

  describe '#correct_letter?' do
    before do
      allow(game).to receive(:secret_word).and_return('bread')
    end

    context 'when letter is a part of the secret word' do
      it 'returns true' do
        guess = 'a'
        expect(game.correct_letter?(guess)).to eq(true)
      end
    end

    context 'when letter is not a part of the secret word' do
      it 'returns false' do
        guess = 'z'
        expect(game.correct_letter?(guess)).to eq(false)
      end
    end
  end

  describe '#indices_of_letter' do
    before do
      allow(game).to receive(:secret_word).and_return('kneel')
    end

    it 'returns the indices of a letter in the secret word' do
      guess = 'e'

      expect(game.indices_of_letter(guess)).to eq([2, 3])
    end

    describe '#update_guess_word' do
      before do
        allow(game).to receive(:guess_word).and_return(%w[_ _ _ _ _])
      end

      it 'updates @guessword with guessed letter' do
        guess = 'e'
        indices = [2, 3]
        # binding.pry
        expect { game.update_guess_word(guess, indices) }
          .to change { game.instance_variable_get(:@guess_word) }
          .to(%w[_ _ e e _])
      end
    end
  end
end
