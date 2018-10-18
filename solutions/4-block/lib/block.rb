require 'colorize'
require 'digest'
require_relative 'helpers'

class Block
  attr_reader :own_hash, :msg, :prev_block_hash

  def initialize(prev_block, msg)
    @msg = msg
    @prev_block_hash = prev_block.own_hash if prev_block
    @own_hash = hash
  end

  def valid?
    # TODO check signature of the message
    @msg.is_valid_signature?
  end

  def to_s
    [
      "",
      "-" * 80,
      "Previous hash: ".rjust(15) + @prev_block_hash.to_s.yellow,
      "Message: ".rjust(15) + @msg.content.green,
      "From: ".rjust(15) + @msg.from_short.blue,
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

  def hash
    Digest::SHA256.hexdigest(full_block)
  end

  def full_block
    JSON.dump([@msg.to_h, @prev_block_hash])
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
    @blocks.length
  end

  def to_s
    @blocks.map(&:to_s).join("\n")
  end

  def to_a_of_h
    @blocks.map(&:to_h)
  end
end
