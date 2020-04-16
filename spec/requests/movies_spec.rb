require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  describe 'GET /movies' do
    let!(:movie) { create(:movie) }
    it 'returns success code' do
      get '/api/v1/movies'
      expect(response).to have_http_status(200)
    end

    it 'return all movies' do
      movies = Movie.all
      get '/api/v1/movies'
      expect(JSON.parse(response.body)).to eq(JSON.parse(movies.to_json))
    end

    it 'returns specific movie for a valid id' do
      movie = Movie.first
      get "/api/v1/movies/#{movie.id}"
      expect(JSON.parse(response.body)).to eq(JSON.parse(movie.to_json))
    end

    it 'returns 404 status for an invalid id' do
      get '/api/v1/movies/1000'
      expect(response).to have_http_status(404)
    end

    it 'returns record not found error for an invalid id' do
      get '/api/v1/movies/1000'
      expect(JSON.parse(response.body)['error']).to eq('Record Not Found')
    end
  end

  describe 'POST /movies' do
    let!(:params) { { title: 'some movie title', rating: 7, url: 'movie.com' } }

    context 'Valid params' do
      it 'creates a new movie' do
        post '/api/v1/movies', params: params
        expect(JSON.parse(response.body)['movie']['title']).to eq('some movie title')
      end

      it 'returns 201 status' do
        post '/api/v1/movies', params: params
        expect(response.status).to eq(201)
      end
    end

    context 'Invalid params' do
      it 'returns empty title error' do
        params[:title] = ''
        post '/api/v1/movies', params: params
        puts response.body.inspect
        expect(JSON.parse(response.body)['error']).to eq('title is empty')
      end

      it 'returns validation error' do
        params.delete(:title)
        post '/api/v1/movies', params: params
        puts response.body.inspect
        expect(JSON.parse(response.body)['error']).to eq('title is missing, title is empty')
      end
    end
  end

  describe 'PUT /movies/:id' do
    let!(:movie_attrs) { attributes_for(:movie) }
    let!(:movie) { create(:movie) }

    context 'Valid params' do
      it 'updates the existing record' do
        put "/api/v1/movies/#{movie.id}", params: movie_attrs
        expect(movie.reload.title).to eq(movie_attrs[:title])
      end

      it 'returns success response' do
        put "/api/v1/movies/#{movie.id}", params: movie_attrs
        expect(JSON.parse(response.body)['message']).to eq('Movie updated successfully')
      end
    end

    context 'Invalid params' do
      it 'returns validation error' do
        movie_attrs.delete(:title)
        put "/api/v1/movies/#{movie.id}", params: movie_attrs
        expect(JSON.parse(response.body)['error']).to eq('title is missing, title is empty')
      end

      it 'returns validation error' do
        movie_attrs[:title] = nil
        put "/api/v1/movies/#{movie.id}", params: movie_attrs
        expect(JSON.parse(response.body)['error']).to eq('title is empty')
      end
    end
  end

  describe 'DELETE /movies/:id' do
    let!(:movie) { create(:movie) }
    context 'Valid movie ID' do
      it 'deletes the movie' do
        delete "/api/v1/movies/#{movie.id}"
        expect(JSON.parse(response.body)['message']).to eq('Movie deleted successfully')
      end
    end

    context 'Invalid movie ID' do
      it 'deletes the movie' do
        delete '/api/v1/movies/1000'
        expect(JSON.parse(response.body)['error']).to eq('Record Not Found')
      end
    end
  end
end
