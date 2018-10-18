require 'colorize'
require 'digest'
require_relative 'helpers'

class Block
  NUM_ZEROES = 4
  attr_reader :own_hash, :prev_block_hash, :txn, :difficulty

  def initialize(prev_block, txn, difficulty = 2)
    @txn = txn
    @prev_block_hash = prev_block.own_hash if prev_block
    @difficulty = difficulty
    mine_block!
  end

  def mine_block!
    # TODO calculate the nonce and add it to the full_block
    @nonce = calc_nonce
    @own_hash = hash(full_block(@nonce))
  end

  def valid?
    ## TODO add
    is_valid_nonce?(@nonce) && @txn.is_valid_signature?
  end

  def to_s
    [
      "",
      "-" * 80,
      "Previous hash: ".rjust(15) + @prev_block_hash.to_s.yellow,
      "From: ".rjust(15) + @txn.from_short.blue,
      "To: ".rjust(15) + @txn.to_short.green,
      "Amount: ".rjust(15) + @txn.amount.to_s.cyan,
      "Nonce: ".rjust(15) + @nonce.to_s.red,
      "Own hash: ".rjust(15) + @own_hash.yellow,
      "-" * 80,
      "|".rjust(40),
      "|".rjust(40),
      "↓".rjust(40),
    ].join("\n")
  end

  def to_h
    { own_hash: @own_hash, txn: @txn.to_h, prev_block_hash: @prev_block_hash }
  end

  private

  def calc_nonce
    # TODO find the right nonce
    nonce = 0
    until is_valid_nonce?(nonce)
      print "." if nonce % 100_000 == 0
      nonce += 1
    end
    nonce
  end

  def is_valid_nonce?(nonce)
    hash(full_block(nonce)).start_with?("0" * @difficulty)
  end

  def hash(contents)
    Digest::SHA256.hexdigest(contents)
  end

  def full_block(nonce)
    JSON.dump([@txn.to_h, @prev_block_hash, nonce.to_s])
  end
end

class BlockChain
  attr_reader :blocks

  def initialize(genesis_txn)
    @blocks = []
    @blocks << Block.new(nil, genesis_txn)
  end

  def add_to_chain(txn)
    @blocks << Block.new(@blocks.last, txn)
  end

  def valid?
    @blocks.all? { |block| block.is_a?(Block) } &&
      @blocks.all?(&:valid?) &&
      @blocks.each_cons(2).all? { |a, b| a.own_hash == b.prev_block_hash } &&
      all_spends_valid?
  end

  def all_spends_valid?
    compute_balances do |balances, from, to|
      return false if balances.values_at(from, to).any? { |bal| bal < 0 }
    end
    true
  end

  def compute_balances
    genesis_txn = @blocks.first.txn
    balances = { genesis_txn.to => genesis_txn.amount }
    balances.default = 0 # New people automatically have balance of 0
    @blocks.drop(1).each do |block| # Ignore the genesis block
      from = block.txn.from
      to = block.txn.to
      amount = block.txn.amount

      balances[from] -= amount
      balances[to] += amount
      yield balances, from, to if block_given?
    end
    balances
  end

  def length
    ## TODO get diffucilty
    @blocks.map(&:difficulty).inject(0) { |sum, n| sum + 16**n }
  end

  def to_s
    @blocks.map(&:to_s).join("\n")
  end

  def to_a_of_h
    @blocks.map(&:to_h)
  end
end
