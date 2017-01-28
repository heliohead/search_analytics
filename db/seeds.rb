require 'ffaker'

if Article.count.zero?
  30.times do
    Article.create(
      title: FFaker::HipsterIpsum.phrase,
      text: FFaker::HipsterIpsum.paragraphs
    )
  end
end
