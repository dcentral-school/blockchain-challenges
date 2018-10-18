require 'colorize'
require 'digest'
require_relative 'helpers'

class Block
  NUM_ZEROES = 4
  attr_reader :own_hash, :prev_block_hash, :difficulty

  def initialize(prev_block, msg, difficulty = 2)
    # TODO add difficulty and mine the block!

  end

  def mine_block!
    # TODO calculate the nonce and add it to the full_block

  end

  def valid?
    ## TODO update your validation with validity of the nonce

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

  end

  def is_valid_nonce?(nonce)
    # TODO Check the validity of the nonce with the @difficulty

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
    # TODO Copy from the previous exercise

  end

  def add_to_chain(msg)
    # TODO Copy from the previous exercise

  end

  def valid?
    # TODO copy from previous exercise
  end

  def length
    ## TODO get difficulty: sum(16^diff)

  end

  def to_s
    @blocks.map(&:to_s).join("\n")
  end

  def to_a_of_h
    @blocks.map(&:to_h)
  end
end
