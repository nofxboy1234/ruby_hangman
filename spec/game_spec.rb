require './lib/game'

RSpec.describe Game do
  subject(:game_normal) { described_class.new(dictionary_google) }
  let(:dictionary_google) { double('dictionary', valid_words: ['kittens']) }
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

  describe '#update_guess_word' do
    context 'when the guessed letter is a letter inside the secret word' do
      let(:letter) { 'n' }

      it 'updates the guess_word array at the indices where the guessed letter is found' do
        allow(game_normal).to receive(:secret_word).and_return(secret)
        game_normal.update_guess_word(letter)

        expect(game_normal.instance_variable_get(:@guess_word)).to eq(%w[_ n _ _ _])
      end
    end

    context 'when the guessed letter appears multiple times in the secret word' do
      let(:letter) { 'e' }

      it 'updates the guess_word array at the indices where the guessed letter is found' do
        allow(game_normal).to receive(:secret_word).and_return(secret)
        game_normal.update_guess_word(letter)

        expect(game_normal.instance_variable_get(:@guess_word)).to eq(%w[_ _ e e _])
      end
    end
  end

  describe '#update_incorrect_guesses' do
    let(:guess) { 'x' }

    it 'appends a guess to the incorrect_guesses array' do
      expect { game_normal.update_incorrect_guesses(guess) }
        .to change { game_normal.instance_variable_get(:@incorrect_guesses) }
        .to(['x'])
    end
  end

  describe '#decrement_guesses' do
    it 'decreases @guess_count by 1' do
      expect { game_normal.decrement_guesses }
        .to change { game_normal.guess_count }.by(-1)
    end
  end

  describe '#select_word' do
    it 'updates @secret_word' do
      expect { game_normal.select_word }
        .to change { game_normal.secret_word }.to('kittens')
    end
  end

  describe '#save' do
    it 'writes the yaml string to a file' do
      expect(File).to receive(:open).with('save_file', 'w')
      game_normal.save
    end
  end

  describe '.load' do
    it 'loads the yaml string from a file into an object' do
      allow(Game).to receive(:read_yaml_from_file)

      expect(YAML).to receive(:safe_load)
      Game.load
    end
  end

  describe '.read_yaml_from_file' do
    it 'reads the yaml string from a file' do
      expect(File).to receive(:open).with('save_file', 'r')
      Game.read_yaml_from_file
    end
  end

  describe '#to_yaml' do
    let(:secret_word) { 'kittens' }
    let(:guess_count) { 5 }
    let(:dictionary) { dictionary_google }
    let(:incorrect_guesses) { %w[x y] }
    let(:guess_word) { %w[k _ t t _ _ s] }

    let(:data_to_save) do
      {
        secret_word: secret_word,
        guess_count: guess_count,
        dictionary: dictionary,
        incorrect_guesses: incorrect_guesses,
        guess_word: guess_word
      }
    end

    it 'converts object to yaml string' do

      allow(game_normal).to receive(:secret_word).and_return(secret_word)
      allow(game_normal).to receive(:guess_count).and_return(guess_count)
      allow(game_normal).to receive(:dictionary).and_return(dictionary)
      allow(game_normal).to receive(:incorrect_guesses).and_return(incorrect_guesses)
      allow(game_normal).to receive(:guess_word).and_return(guess_word)

      expect(YAML).to receive(:dump).with(data_to_save)
      game_normal.to_yaml
    end
  end
end
