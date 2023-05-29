require './lib/game'

RSpec.describe Game do
  subject(:game) { described_class.new }

  describe '#load_dictionary' do
    context 'when the dictionary is loaded successfully from the text file' do
      it 'returns true' do
        text_file = 'google-10000-english-no-swears'
        expect(game.load_dictionary(text_file)).to eq(true)
      end
    end
  end
end