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

  describe '#player_turn' do
    before do
      allow(game_normal).to receive(:display_info)
      allow(game_normal).to receive(:puts)
      allow(game_normal).to receive(:secret_word).and_return('kneel')
    end

    context 'when player enters a correct letter' do
      before do
        allow(game_normal).to receive(:gets).and_return('l')
      end

      it 'updates @guess_word' do
        expect { game_normal.player_turn }.to change { game_normal.guess_word }
          .from(%w[_ _ _ _ _]).to(%w[_ _ _ _ l])
      end

      it 'updates @guess_word' do
        allow(game_normal).to receive(:guess_word).and_return(%w[k n e e _])

        expect { game_normal.player_turn }.to change { game_normal.guess_word }
          .from(%w[k n e e _]).to(%w[k n e e l])
      end
    end

    context 'when player enters an incorrect letter' do
      before do
        allow(game_normal).to receive(:gets).and_return('x')
      end

      it 'does not update @guess_word' do
        expect { game_normal.player_turn }.not_to change { game_normal.guess_word }
      end

      it 'updates @incorrect_guesses' do
        expect { game_normal.player_turn }.to change { game_normal.incorrect_guesses }
          .from([]).to(['x'])
      end

      it 'updates @incorrect_guesses' do
        allow(game_normal).to receive(:incorrect_guesses).and_return(['z'])

        expect { game_normal.player_turn }.to change { game_normal.incorrect_guesses }
          .from(['z']).to(['z', 'x'])
      end

      it 'updates @guesses' do
        expect { game_normal.player_turn }.to change { game_normal.guess_count }
          .from(7).to(6)
      end

      it 'updates @guesses' do
        game_normal.player_turn
        game_normal.player_turn

        expect { game_normal.player_turn }.to change { game_normal.guess_count }
          .from(5).to(4)
      end
    end
  end
end
