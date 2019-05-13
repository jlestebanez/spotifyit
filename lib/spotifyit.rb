require 'faraday'
require 'faraday_middleware'
require 'oj'

module SpotifyIt

  class Client
    ACCOUNT_BASE_URL  = 'https://accounts.spotify.com/'.freeze
    API_BASE_URL      = 'https://api.spotify.com/'.freeze

    def auth(client_id, client_secret)
      @token = nil
      conn = Faraday.new(url: ACCOUNT_BASE_URL) do |c|
        c.request :url_encoded
        c.response :json
        c.adapter  :net_http
      end

      conn.basic_auth(client_id, client_secret)

      res = conn.post('/api/token', {grant_type: 'client_credentials'})
      @token = res.body.fetch('access_token') if res.success?
    end

    def track(url)
      return nil if url.nil?

      id = url.split('/').last.split('?').first

      conn = Faraday.new(url: API_BASE_URL) do |c|
        c.request :url_encoded
        c.adapter  :net_http
      end
      conn.token_auth @token
      res =  conn.get("/v1/tracks/#{id}") do |r|
        r.headers['Authorization'] = "Bearer #{@token}"
      end

      parse_track(Oj.load(res.body)) if res.success?
    end

    def authenticated?
      !@token.nil?
    end

    private

    def parse_track(response)
      {
          artist: response['artists'][0]['name'],
          album: response['album']['name'],
          cover: response['album']['images'][0]['url'],
          title: response['name'],
          length: response['duration_ms']
      }
    rescue
      {}
    end
  end

end