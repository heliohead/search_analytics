###
#  Since this not hit the real server i don't perfom more test i learn that test
#  middleware with a feature maybe be a better choice
###

describe SearchPerform do
  let(:app) { MockRackApp.new }
  subject { described_class.new(app) }

  context 'when call searches paths' do
    let(:request) { Rack::MockRequest.new(subject) }

    context "with some particular data" do
      let(:search_term) { 'Elvis is dead?' }

      it "passes the request through unchanged" do
        request.get('/searches', search_term: search_term, 'CONTENT_TYPE' => 'application/json')
        expect(app['CONTENT_TYPE']).to eq('application/json')
      end
    end
  end
end
