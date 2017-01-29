class SearchesController < ApplicationController
  def index
    @searches = Search.searched_sentences
  end
end
