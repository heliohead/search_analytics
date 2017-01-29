class SearchPerform
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless search_or_index?(env['REQUEST_PATH'])
    respond_with_json(env)
  end

  private

  def search_or_index?(request_path)
    request_path == '/search_index' || request_path == '/searches'
  end

  def respond_with_json(env)
    search_term = Rack::Request.new(env).params['query']
    return @app.call(env) unless search_term

    case env['REQUEST_PATH']
    when '/search_index'
      Search.index_sentence(search_term)
      [200, {'Content-Type' => 'application/json'}, [{ search_term_indexed: search_term }.to_json]]
    when '/searches'
      resulted_search = Search.search_for_term(search_term)
      [200, {'Content-Type' => 'application/json'}, [resulted_search.to_json]]
    end
  end
end
