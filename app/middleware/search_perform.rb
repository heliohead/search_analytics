class SearchPerform
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless search_or_index?(env['REQUEST_PATH'])
    respond_with_json(env['REQUEST_PATH'])
  end

  private

  def search_or_index?(request_path)
    request_path == '/search_index' || request_path == '/searches'
  end

  def respond_with_json(request_path)
    case request_path
    when '/search_index'
      [200, {'Content-Type' => 'application/json'}, [{ response: 'ok' }.to_json]]
    when '/searches'
      require 'pry'; binding.pry
      [200, {'Content-Type' => 'application/json'}, [{ response: 'seaches' }.to_json]]
    end
  end
end
