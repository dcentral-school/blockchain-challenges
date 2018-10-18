require_relative 'pki'

class Transaction
  attr_reader :from, :to, :amount
  def initialize(params)
    @from = params['from']
    @to = params['to']
    @amount = params['amount']
    @signature = params['signature'] || PKI.sign(message, params['priv_key'])
  end

  def is_valid_signature?
    return true if genesis_txn? # genesis transaction is always valid
    begin
      PKI.valid_signature?(message, @signature, @from)
    rescue OpenSSL::PKey::RSAError => e
      puts " \/!\\ " * 10
      puts e.to_s
      puts " \/!\\ " * 10
      false
    end
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
