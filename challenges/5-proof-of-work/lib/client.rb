require 'faraday'
require 'json'

PORT = 1111 if PORT.nil?

class Client
  def self.gossip(host, peers, blockchain_json)
    begin
      Faraday.post("http://#{host}:#{PORT}/gossip", {peers: peers, blockchain: blockchain_json}.to_json, :content_type => 'application/json').body
    rescue Faraday::ConnectionFailed => e
      raise
    end
  end

  def self.get_pub_key(host)
    Faraday.get("http://#{host}:#{PORT}/pub_key", :content_type => 'application/json').body
  end

  def self.send_message(host, msg_h)
    Faraday.post("http://#{host}:#{PORT}/send_message", msg_h.to_json, :content_type => 'application/json').body
  end
end
