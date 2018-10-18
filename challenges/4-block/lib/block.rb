require 'colorize'
require 'digest'
require_relative 'helpers'

class Block
  attr_reader :own_hash, :msg, :prev_block_hash

  def initialize(prev_block, msg)
    # TODO initialize the message with the params. Attention params can be msg in JSON with

  end

  def valid?
    # TODO check signature of the message
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
    # TODO initialize the array of blocks and create the Genesis Block

  end

  def add_to_chain(msg)
    # TODO add block to the blockchain

  end

  def valid?
    # TODO Check instance of the blocks, their validity and chech the previous hashes

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
