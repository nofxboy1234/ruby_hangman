require './lib/dictionary'

RSpec.describe Dictionary do
  subject(:dictionary) { described_class.new(text_file) }
  let(:text_file) { 'text_file.txt' }

  describe '#load_text_file' do
    it 'sends readlines message to File' do
      expect(File).to receive(:readlines)
      dictionary.load_text_file
    end

    it 'sets the value of @words' do
      allow(File).to receive(:readlines).and_return(%w[kittens puppies])

      expect { dictionary.load_text_file }.to change { dictionary.words }
        .to(%w[kittens puppies])
    end

    context 'when the dictionary is loaded successfully from the text file' do
      it 'does not raise an error' do
        allow(File).to receive(:readlines).and_return(%w[kittens puppies])

        expect(dictionary).not_to receive(:puts).with('Error while reading file text_file.txt')
        dictionary.load_text_file
      end
    end

    context 'when rescuing an error' do
      before do
        allow(File).to receive(:readlines).and_raise(Errno::ENOENT)
        allow(dictionary).to receive(:puts)
      end

      it 'outputs two error messages' do
        expect(dictionary).to receive(:puts).with('Error while reading file text_file.txt')
        expect(dictionary).to receive(:puts).with(Errno::ENOENT)

        dictionary.load_text_file
      end

      it 'does not raise an error' do
        expect { dictionary.load_text_file }.not_to raise_error
      end
    end
  end
end
