# frozen_string_literal: true

RSpec.describe PlainQuery do
  describe 'valid query' do
    let!(:book) { Book.create(name: 'A fantastic book', genre: 'fantastic', price: 200, discount: 10) }
    let!(:book2) { Book.create(name: 'B science book', genre: 'science', price: 150, discount: 0) }
    let!(:book3) { Book.create(name: 'C another fantastic book', genre: 'fantastic', price: 50, discount: 0) }
    let!(:book4) { Book.create(name: 'D another science book', genre: 'science', price: 700, discount: 15) }

    describe 'BooksQuery' do
      subject { BooksQuery.call(Book.all, options) }

      context 'without options' do
        let(:options) { {} }
        let(:expected_collection) { [book, book2, book3, book4] }

        it { is_expected.to eq(expected_collection) }
      end

      context 'with options' do
        context 'with filter by name' do
          let(:options) { { name: 'another' } }
          let(:expected_collection) { [book3, book4] }

          it { is_expected.to eq(expected_collection) }
        end

        context 'with filter by genre' do
          let(:options) { { genre: 'fantastic' } }
          let(:expected_collection) { [book, book3] }

          it { is_expected.to eq(expected_collection) }
        end

        context 'with filter by price' do
          let(:options) { { price: 170 } }
          let(:expected_collection) { [book, book4] }

          it { is_expected.to eq(expected_collection) }
        end

        context 'with filter by discount' do
          let(:options) { { discount: 10 } }
          let(:expected_collection) { [book, book4] }

          it { is_expected.to eq(expected_collection) }
        end
      end
    end

    describe 'BestBooksQuery' do
      let!(:bad_book_review) do
        BookReview.create(book: book, description: 'example review', rate: BookReview.rates[:bad])
      end
      let!(:good_book_review) do
        BookReview.create(book: book, description: 'example review 1', rate: BookReview.rates[:good])
      end

      let!(:bad_book2_review) do
        BookReview.create(book: book2, description: 'example review 2', rate: BookReview.rates[:bad])
      end

      let!(:good_book3_review) do
        BookReview.create(book: book3, description: 'example review 3', rate: BookReview.rates[:good])
      end

      context 'with model scope' do
        subject do
          Book.send(:scope, :best, BestBooksQuery)
          Book.best
        end

        let(:expected_collection) { [book, book3] }

        it { is_expected.to eq(expected_collection) }
      end

      context 'with query execution' do
        subject { BestBooksQuery.call(Book.all) }

        let(:expected_collection) { [book, book3] }

        it { is_expected.to eq(expected_collection) }
      end
    end
  end

  describe 'invalid query' do
    subject { InvalidBooksQuery.call(Book.all) }

    it { expect { subject }.to raise_exception('Scope must be ActiveRecord::Relation') }
  end
end
