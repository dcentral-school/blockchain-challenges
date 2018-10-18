require 'colorize'
require 'digest'
require_relative 'helpers'

class Block
  NUM_ZEROES = 4
  attr_reader :own_hash, :prev_block_hash, :txn, :difficulty

  def initialize(prev_block, txn, difficulty = 2)
    # TODO Copy from the previous exercise

  end

  def mine_block!
    # TODO Copy from the previous exercise

  end

  def valid?
    # TODO Copy from the previous exercise

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
    # TODO Copy from the previous exercise

  end

  def is_valid_nonce?(nonce)
    # TODO Copy from the previous exercise

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
    # TODO Update from the previous exercise with genesis_txn

  end

  def add_to_chain(txn)
    # TODO Copy from the previous exercise

  end

  def valid?
    # TODO Copy from the previous exercise and check the validity of the spends

  end

  def all_spends_valid?
    # TODO check if any balance is < 0

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
