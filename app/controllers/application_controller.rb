class ApplicationController < Sinatra::Base

    # Add this line to set the Content-Type header for all responses
  set :default_content_type, 'application/json'

  get '/' do
    { message: "Hello world" }.to_json
  end

  get '/games' do
     # Get all the games from the database, order them by title name and limit the results to 10
    games = Game.all.order(:title).limit(10)
      # Return a JSON response with an array of all the game data
    games.to_json
  end

  # Use the :id syntax to create a dynamic route
  get '/games/:id' do
      # Look up the game in the database using its ID
    game = Game.find(params[:id])

      # Send a JSON-formatted response of the game data, including reviews. This only works because our Game model has the correct associations set up.
    # game.to_json(include: :reviews)

      # Or we could include users associated with each review
    # game.to_json(include: { reviews: { include: :user } })

      # You can use "only" to limit results
      game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
    
  end
end
