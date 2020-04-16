json.extract! movie, :id, :title, :rating, :url, :created_at, :updated_at
json.url movie_url(movie, format: :json)
