require 'json'
require_relative 'pki'

class Message
  attr_reader :content, :from
  def initialize(params)
    # TODO initialize the message with the params. Attention params can be msg in JSON with
    # the signature or can contain the Private Key to signe the message

  end

  def is_valid_signature?
    # TODO check if the signature is good, rescue the error if not correct

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
    # TODO return the keys of the instance in a hash

  end
end
