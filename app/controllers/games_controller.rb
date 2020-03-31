require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def score
    @word = (params[:word] || "").upcase
    @letters = params[:letters].split
    @check = call_api(@word)
    @included = included?(@word, @letters)
  end

  def call_api(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
