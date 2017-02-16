class JwtAuth

  def initialize app
    @app = app
    @jwt_issuer = 'zoral.com'
    @jwt_secret = 'keepitsecret'
  end

  def call env
    begin
      options = {algorithm: 'HS256', iss: @jwt_issuer}
      bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      payload, header = JWT.decode bearer, @jwt_secret, true, options

      env[:scopes] = payload['scopes']
      env[:customer] = payload['customer']

      @app.call env
    rescue JWT::DecodeError
      env[:customer] = 'not_authorized'
      @app.call env
    rescue JWT::ExpiredSignature
      env[:customer] = 'not_authorized'
      @app.call env
    rescue JWT::InvalidIssuerError
      env[:customer] = 'not_authorized'
      @app.call env
    rescue JWT::InvalidIatError
      env[:customer] = 'not_authorized'
      @app.call env
    end
  end

end