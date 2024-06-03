require 'open-uri'

class GamesController < ApplicationController
  def new
    @grille = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @grille = params[:grille]
    @mot = params[:word]
    if @mot.upcase.chars.all? { |letter| @mot.upcase.chars.count(letter) <= @grille.split(' ').count(letter) }
      if english_word?(@mot)
        @result = "Congratulations !! #{@mot} is a valid english word."
        session[:score] ||= 0
        session[:score] += (@mot.chars.length * @mot.chars.length)
        @score = session[:score]
      else
        @result = "Sorry, #{@mot} is not an english word."
      end
    else
      @result = "Sorry, #{@mot} cannot be spelled with the letters #{@grille}."
    end
  end

end

def english_word?(word)
  response = URI.parse("https://dictionary.lewagon.com/#{word}")
  json = JSON.parse(response.read)
  json['found']
end
