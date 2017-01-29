###
# Ok this logic become a little bit complicate, maybe split into two classes
#
###
require 'rails_helper'
require 'ffaker'

RSpec.describe Search, type: :model do
  context 'search sugestions' do
    it 'return list of sugestions' do
      term = 'Elvis is dead'
      $redis.zincrby "search_sugestions:#{term.downcase}", 1, term.downcase

      expect(Search.search_for_term(term)).to be_a(Hash)
      expect(Search.search_for_term(term)).to include(:suggestions)
    end
  end

  context 'index articles for sugestions' do
    it 'articles must be indexed' do
      2.times do
        Article.create(
          title: FFaker::HipsterIpsum.phrase,
          text: FFaker::HipsterIpsum.paragraphs)
      end

      Search.index_articles_for_sugestions

      expect($redis.keys).to_not be_empty
    end
  end

  context 'index searched sentences' do
    it 'return a hash with searched sentences' do
      article = Article.create( title: FFaker::HipsterIpsum.phrase, text: FFaker::HipsterIpsum.paragraphs)
      Search.index_terms_for_search(article.title)
      Search.index_sentence(article.title)

      expect(Search.searched_sentences).to eq({ reached: { article.title => '1' }, not_reached: {} })
      expect(Search.searched_sentences).to be_a(Hash)
    end

    it 'retun a hash with searched sentences not reached' do
      article = Article.create( title: FFaker::HipsterIpsum.phrase, text: FFaker::HipsterIpsum.paragraphs)
      sentence = 'Nada em portugues aqui'
      Search.index_articles_for_sugestions
      Search.index_sentence(sentence)

      expect(Search.searched_sentences).to include({ reached: {}, not_reached: { sentence => '1' } })
    end

    it 'removes non alphanumerics from strings' do
      expect(Search.sanitize('Elvis . is ? Dead')).to eq('elvis is dead')
    end
  end
end
