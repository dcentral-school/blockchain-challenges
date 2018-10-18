require_relative 'pki'

class Transaction
  attr_reader :from, :to, :amount
  def initialize(params)
    # TODO Inspired by the Message class initialize with the params

  end

  def is_valid_signature?
    return true if genesis_txn? # genesis transaction is always valid
    # TODO Copy from the previous exercise in Message
  end

  def genesis_txn?
    from.nil?
  end

  def message
    Digest::SHA256.hexdigest([@from, @to, @amount].to_json)
  end

  def from_short
    @from ? PKI.short_pub_key(@from) : ""
  end

  def to_short
    PKI.short_pub_key(@to)
  end

  def to_s
    message
  end

  def to_h
    { from: @from, to: @to, amount: @amount, signature: @signature }
  end
end
