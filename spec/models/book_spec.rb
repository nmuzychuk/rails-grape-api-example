require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:book)).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without a title' do
      expect(build(:book, title: nil)).to be_invalid
    end

    it 'is invalid without with a long title' do
      expect(build(:book, title: Faker::Lorem.characters(number: 50))).to be_invalid
    end

    it 'is invalid without with a long title' do
      expect(build(:book, title: Faker::Lorem.characters(number: 50))).to be_invalid
    end
  end

  describe 'scopes' do
    context 'lengthy' do
      let!(:long_book) { create(:book, page_count: 1000) }
      let!(:short_book) { create(:book, page_count: 300) }

      it 'includes a long book' do
        expect(Book.lengthy).to include(long_book)
      end

      it 'excludes a short book' do
        expect(Book.lengthy).not_to include(short_book)
      end
    end
  end
end
