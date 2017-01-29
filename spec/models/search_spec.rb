require 'rails_helper'
require 'ffaker'
$redis = MockRedis.new

RSpec.describe Search, type: :model do
  context 'search sugestions' do
    it 'return list of sugestions' do
      term = 'Elvis is dead'
      $redis.zincrby "search_sugestions:#{term.downcase}", 1, term.downcase

      expect(Search.search_for_term(term)).to be_a(Array)
      expect(Search.search_for_term(term)).to include(term.downcase)
    end
  end

  context 'index articles for sugestions' do
    it 'articles must be indexed' do
      $redis.flushall
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
      expect(Search.searched_sentences).to be_a(Hash)
    end

    it 'include sentence' do
      sentence = 'Elvis is dead'
      Search.index_sentence(sentence)

      expect(Search.searched_sentences).to include(sentence)
    end
  end
end
