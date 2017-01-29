class Search
  class << self
    def searched_sentences
      { reached: $redis.hgetall('searchers'), not_reached: $redis.hgetall('searchers_not_reached') }
    end

    def index_sentence(sentence)
      if $redis.keys.include?("search_sugestions:#{sanitize(sentence)}")
        $redis.hincrby('searchers', sentence, 1)
      else
        $redis.hincrby('searchers_not_reached', sentence, 1)
      end
    end

    def search_for_term(term)
      $redis.zrevrange "search_sugestions:#{sanitize(term)}", 0, 9
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
        $redis.zincrby "search_sugestions:#{sanitize(prefix)}", 1, sanitize(term)
      end
    end

    def sanitize(string)
      string.downcase.gsub(/[^0-9a-z ]/i, '').squish
    end
  end
end
