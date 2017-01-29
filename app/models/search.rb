class Search
  class << self
    def searched_sentences
      $redis.hgetall 'searchers'
    end

    def index_sentence(sentence)
     $redis.hincrby('searchers', sentence, 1)
    end

    def search_for_term(term)
      $redis.zrevrange "search_sugestions:#{term.downcase}", 0, 9
    end

    def index_articles_for_sugestions
      Article.all.each do |article|
        index_terms_for_search(article.title)
        index_terms_for_search(article.text)
        article.title.split.each { |letter| index_terms_for_search(letter) }
      end
    end

    def index_terms_for_search(term)
      1.upto(term.size - 1) do |num|
        prefix = term[0, num]
        $redis.zincrby "search_sugestions:#{prefix.downcase}", 1, term.downcase
      end
    end
  end
end
