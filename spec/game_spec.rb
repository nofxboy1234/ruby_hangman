require './lib/game'

RSpec.describe Game do
  subject(:game) { described_class.new('dictionary_a.txt') }
  let(:text_file) { 'dictionary_b.txt' }
  let(:dictionary) { %w[cat dogs bread kittens puppies abbreviating factorizations] }

  before do
    allow(File).to receive(:readlines).and_return(dictionary)
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

    context 'when input is consecutive letters that are a part of the secret word' do
      it 'returns false' do
        guess = 'br'
        expect(game.correct_letter?(guess)).to eq(false)
      end
    end
  end

  describe '#update_guess_word' do
    before do
      allow(game).to receive(:secret_word).and_return('kneel')
    end

    it 'updates @guessword with correctly guessed letters' do
      guess = 'e'
      expect { game.update_guess_word(guess) }
        .to change { game.instance_variable_get(:@guess_word) }
        .to(%w[_ _ e e _])
    end
  end

  describe '#decrement_guesses' do
    it 'decreases @guesses by 1' do
      expect { game.decrement_guesses }.to change { game.guesses }.by(-1)
    end
  end

  describe '#update_incorrect_guesses' do
    it 'appends incorrectly guessed letter to @incorrect_guesses' do
      guess = 'x'

      expect { game.update_incorrect_guesses(guess) }
        .to change { game.incorrect_guesses.size }.by(1)
    end
  end

  describe '#over?' do
    context 'when player guesses the secret word and there are guesses left' do
      before do
        allow(game).to receive(:secret_word_guessed?).and_return(true)
        allow(game).to receive(:no_more_guesses_left?).and_return(false)
      end

      it 'is game over' do
        expect(game).to be_over
      end
    end

    context 'when player has not guessed the secret word and there are no guesses left' do
      before do
        allow(game).to receive(:secret_word_guessed?).and_return(false)
        allow(game).to receive(:no_more_guesses_left?).and_return(true)
      end

      it 'is game over' do
        expect(game).to be_over
      end
    end
  end

  describe '#no_more_guesses_left?' do
    context 'when guesses is zero' do
      before do
        allow(game).to receive(:guesses).and_return(0)
      end

      it 'returns true' do
        expect(game.no_more_guesses_left?).to eq(true)
      end
    end

    context 'when guesses is not zero' do
      before do
        allow(game).to receive(:guesses).and_return(1)
      end

      it 'returns false' do
        expect(game.no_more_guesses_left?).to eq(false)
      end
    end
  end

  describe '#secret_word_guessed?' do
    context 'when player guesses the secret word' do
      before do
        allow(game).to receive(:secret_word).and_return('kneel')
        allow(game).to receive(:guess_word).and_return(%w[k n e e l])
      end

      it 'returns true' do
        expect(game.secret_word_guessed?).to eq(true)
      end
    end

    context 'when player has not guessed the secret word' do
      before do
        allow(game).to receive(:secret_word).and_return('kneel')
        allow(game).to receive(:guess_word).and_return(%w[k n e e _])
      end

      it 'returns false' do
        expect(game.secret_word_guessed?).to eq(false)
      end
    end
  end
end
