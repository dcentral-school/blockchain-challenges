require 'json'
require_relative 'pki'

class Message
  attr_reader :content, :from
  def initialize(params)
    @content = params['content']
    @from = params['from']
    @signature = params['signature'] || PKI.sign(message, params['priv_key'])
  end

  def is_valid_signature?
    begin
      PKI.valid_signature?(message, @signature, @from)
    rescue OpenSSL::PKey::RSAError => e
      puts " \/!\\ " * 10
      puts e.to_s
      puts " \/!\\ " * 10
      false
    end
  end

  def message
    Digest::SHA256.hexdigest([@content, @from].to_json)
  end

  def from_short
    PKI.short_pub_key(@from)
  end

  def to_s
    message
  end

  def to_h
    { content: @content, from: @from, signature: @signature }
  end
end
