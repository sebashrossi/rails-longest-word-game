class GamesController < ApplicationController
  def new
   @letters = []
    10.times do
      @letters << ('A'...'Z').to_a.sample
    end
  end

  def is_included?(word, letters)
    valid = true
    word.upcase.split('').each do |letter|
      if letters.include?(letter)
        a = letters.index(letter)
        letters.delete_at(a)
      else
        valid = false
      end
    end
    valid
  end

  def parsing(parameter)
    url = "https://wagon-dictionary.herokuapp.com/#{parameter}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def score
    @letters = params[:letters].split(' ')
    @word = params[:word]
    res = parsing(@word)
    @result = ''
    if res['found'] && is_included?(@word, @letters)
      @result = "Congratulations! '#{@word}' is a valid word!"
    elsif !is_included?(@word, @letters)
      @result = "Sorry! but '#{@word}' can't be built out of #{params[:letters]}"
    else
      @result = "Sorry! but '#{@word}' does not seem to be a valid English word..."
    end
  end
end
