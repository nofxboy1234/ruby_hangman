require './lib/game'

RSpec.describe Game do
  subject(:game_normal) { described_class.new(dictionary_google) }
  let(:dictionary_google) { double('dictionary') }
  let(:secret) { 'kneel' }

  describe '#over?' do
    context 'when player guesses the secret word and there are guesses left' do
      let(:guess_word_new) { %w[k n e e l] }

      before do
        allow(game_normal).to receive(:guess_word).and_return(guess_word_new)
        allow(game_normal).to receive(:secret_word).and_return(secret)
        allow(game_normal).to receive(:guess_count).and_return(1)
      end

      it 'is game over' do
        expect(game_normal).to be_over
      end
    end

    context 'when player has not guessed the secret word and there are guesses left' do
      let(:guess_word_new) { %w[k n e e _] }

      before do
        allow(game_normal).to receive(:guess_word).and_return(guess_word_new)
        allow(game_normal).to receive(:secret_word).and_return(secret)
        allow(game_normal).to receive(:guess_count).and_return(1)
      end

      it 'is not game over' do
        expect(game_normal).not_to be_over
      end
    end

    context 'when player has not guessed the secret word and there are no guesses left' do
      let(:guess_word_new) { %w[k n e e _] }

      before do
        allow(game_normal).to receive(:guess_word).and_return(guess_word_new)
        allow(game_normal).to receive(:secret_word).and_return(secret)
        allow(game_normal).to receive(:guess_count).and_return(0)
      end

      it 'is game over' do
        expect(game_normal).to be_over
      end
    end

    context 'when player has not guessed the secret word and there are guesses left' do
      let(:guess_word_new) { %w[k n e e _] }

      before do
        allow(game_normal).to receive(:guess_word).and_return(guess_word_new)
        allow(game_normal).to receive(:secret_word).and_return(secret)
        allow(game_normal).to receive(:guess_count).and_return(1)
      end

      it 'is game over' do
        expect(game_normal).not_to be_over
      end
    end
  end

  describe '#correct_letter?' do
    before do
      allow(game_normal).to receive(:secret_word).and_return(secret)
    end

    context 'when the guessed letter is a letter inside the secret word' do
      let(:letter) { 'k' }

      it 'returns true' do
        expect(game_normal.correct_letter?(letter)).to eq(true)
      end
    end

    context 'when the guessed letter is a letter not inside the secret word' do
      let(:letter) { 'z' }
      
      it 'returns false' do
        expect(game_normal.correct_letter?(letter)).to eq(false)
      end
    end
  end
end
