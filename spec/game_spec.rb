require './lib/game'

RSpec.describe Game do
  subject(:game) { described_class.new }

  describe '#load_dictionary' do
    before do
      allow(File).to receive(:readlines).and_return(%w[a b c])
    end

    it 'sets the value of @dictionary' do
      text_file = 'google-10000-english-no-swears.txt'

      expect { game.load_dictionary(text_file) }.to change { game.dictionary }
    end

    it 'sends readlines message to File' do
      text_file = 'google-10000-english-no-swears.txt'

      expect(File).to receive(:readlines)
      game.load_dictionary(text_file)
    end

    context 'when the dictionary is loaded successfully from the text file' do
      it 'does not raise an error' do
        text_file = 'google-10000-english-no-swears.txt'
        
        expect(game).not_to receive(:puts).with('Error while reading file google-10000-english-no-swears.txt')
        game.load_dictionary(text_file)
      end
    end

    context 'when rescuing an error' do
      before do
        allow(File).to receive(:readlines).and_raise(Errno::ENOENT)
        # allow(game).to receive(:puts).twice
        # allow(game).to receive(:puts).with(Errno::ENOENT)
      end

      it 'outputs two error messages' do
        text_file = 'google-10000-english-no-swears.txt'

        expect(game).to receive(:puts).with('Error while reading file google-10000-english-no-swears.txt')
        expect(game).to receive(:puts).with(Errno::ENOENT)
        game.load_dictionary(text_file)
      end
    end
  end
end
