require 'rails_helper'

RSpec.describe "Books", type: :request do

  context 'GET /api/v1/books' do

    context 'Without books' do
      it 'Gets an empty array' do
        get '/api/v1/books'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq []
      end
    end

    context 'With books' do
      let!(:book) { create(:book) }

      it 'Gets an array of books' do
        get '/api/v1/books'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).length).to be >= 1
      end
    end
  end

  context 'GET /api/v1/books/search' do

    context 'With stubbed api request' do
      it 'Searches books' do
        stub_request(:get, "https://www.googleapis.com/books/v1/volumes?q=cleancode").
            with(
                headers: {
                    'Accept' => '*/*',
                    'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'User-Agent' => 'Ruby'
                }).
            to_return(status: 200, body: '{"items": []}', headers: {})

        get '/api/v1/books/search?q=cleancode'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq '{"items": []}'.as_json
      end
    end

    context 'Without a query parameter specified' do
      it 'returns 400' do
        get '/api/v1/books/search'
        expect(response.status).to eq(400)
      end
    end

  end

  context 'POST /api/v1/books' do
    let(:book_attrs) do
      {
          title: "nfmpiwzx00t9brz4u4gornv1x6crb8",
          description: "Cum nisi consequatur eius.",
          page_count: 860
      }
    end
    let(:publisher_attrs) do
      {
          name: 'nfmpiwzx00t9brz'
      }
    end
    let!(:publisher) { create(:publisher) }

    it 'Creates a book' do
      expect {
        post '/api/v1/books', params: {book: book_attrs, publisher: publisher_attrs}
      }.to change { Book.count }.by(1)

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)).to eq Book.last.as_json
    end

    context 'With a new publisher specified in params' do
      it 'Creates a publisher' do
        expect {
          post '/api/v1/books', params: {book: book_attrs, publisher: publisher_attrs}
        }.to change { Publisher.count }.by(1)
      end
    end

    context 'With existing publisher' do
      it 'Does not create a publisher' do
        expect {
          post '/api/v1/books', params: {book: book_attrs, publisher: {name: publisher.name}}
        }.to change { Publisher.count }.by(0)
      end
    end

    context 'With new categories specified in params' do
      let(:categories_attrs) { %w[Fiction Adventure] }

      it 'Creates categories' do
        expect {
          post '/api/v1/books', params: {book: book_attrs, publisher: publisher_attrs, categories: categories_attrs}
        }.to change { Category.count }.by(2)
      end
    end

    context 'With existing categories specified in params' do
      let!(:category1) { create(:category) }
      let!(:category2) { create(:category) }

      let(:categories_attrs) { [category1.name, category2.name] }

      it 'Does not create categories' do
        expect {
          post '/api/v1/books', params: {book: book_attrs, publisher: publisher_attrs, categories: categories_attrs}
        }.to change { Category.count }.by(0)
      end
    end
  end

  context 'GET /api/v1/books:id' do
    let!(:book) { create(:book) }

    it 'Gets a book' do
      get "/api/v1/books/#{book.id}"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq book.as_json
    end

  end

  context 'PUT /api/v1/books:id' do
    let!(:book) { create(:book) }
    let(:new_title) { Faker::Lorem.characters(number: 20) }

    it 'Updates a book' do
      put "/api/v1/books/#{book.id}", params: {book: {title: new_title}}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['title']).to eq new_title
    end
  end

  context 'DELETE /api/v1/books:id' do
    let!(:book) { create(:book) }

    it 'Deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change { Book.count }.by(-1)

      expect(response.status).to eq(200)
    end
  end

end
