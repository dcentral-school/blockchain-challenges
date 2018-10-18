require 'colorize'
require 'digest'
require_relative 'helpers'

class Block
  NUM_ZEROES = 4
  attr_reader :own_hash, :prev_block_hash, :difficulty

  def initialize(prev_block, msg, difficulty = 2)
    @msg = msg
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
    is_valid_nonce?(@nonce) && @msg.is_valid_signature?
  end

  def to_s
    [
      "",
      "-" * 80,
      "Previous hash: ".rjust(15) + @prev_block_hash.to_s.yellow,
      "Message: ".rjust(15) + @msg.content.green,
      "From: ".rjust(15) + @msg.from_short.blue,
      "Nonce: ".rjust(15) + @nonce.to_s.red,
      "Own hash: ".rjust(15) + @own_hash.yellow,
      "-" * 80,
      "|".rjust(40),
      "|".rjust(40),
      "↓".rjust(40),
    ].join("\n")
  end

  def to_h
    { own_hash: @own_hash, msg: @msg.to_h, prev_block_hash: @prev_block_hash }
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
    JSON.dump([@msg.to_h, @prev_block_hash, nonce.to_s])
  end
end

class BlockChain
  attr_reader :blocks

  def initialize(msg)
    @blocks = []
    @blocks << Block.new(nil, msg)
  end

  def add_to_chain(msg)
    @blocks << Block.new(@blocks.last, msg)
    puts @blocks.last
  end

  def valid?
    @blocks.all? { |block| block.is_a?(Block) } &&
      @blocks.all?(&:valid?) &&
      @blocks.each_cons(2).all? { |a, b| a.own_hash == b.prev_block_hash }
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
