require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # before_action :letters #, only: [:index, :show]

  def new
    @letters = generate_grid(10)
  end

  def score
    # raise
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @message = score_message(@word, @letters)
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def score_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "Congratulations! ''#{attempt}'' is a valid English word!"
      else
        "Sorry but ''#{attempt}'' does not seem to be a valid English word..."
      end
    else
      "Sorry but ''#{attempt}'' can't be built out of #{grid.join(', ')}."
    end
  end

  # private

  # def letters
  #   @letters = generate_grid(10)
  # end
end
