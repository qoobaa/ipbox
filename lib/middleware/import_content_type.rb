module Middleware
  class ImportContentType
    def initialize(app, methods = [:post, :patch], path = /^\/projects\/[^\/]+\/import/, content_type = 'application/octet-stream')
      @app = app
      @methods = (methods.is_a?(Array) ? methods : [methods]).map{ |item| item.to_s.upcase }
      @path = path
      @content_type = content_type
    end

    def call(env)
      req = Rack::Request.new(env)

      if match_path?(req.path) and match_method?(req.request_method)
        env['CONTENT_TYPE'] = @content_type
      end

      @app.call(env)
    end

    private

    def match_path?(path)
      @path.is_a?(Regexp) ? @path.match(path.to_s) : @path == path.to_s
    end

    def match_method?(method)
      @methods.empty? || @methods.include?(method)
    end
  end
end

