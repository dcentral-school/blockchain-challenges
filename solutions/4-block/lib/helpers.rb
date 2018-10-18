require_relative 'pki.rb'
require_relative 'block'

Thread.abort_on_exception = true

def every(seconds)
  Thread.new do
    loop do
      sleep seconds
      yield
    end
  end
end

def render_blockchain
  system 'clear'
  puts Time.now.to_s.split[1].light_blue
  puts "My blockchain: " + $BLOCKCHAIN.to_s
  puts "Blockchain length: " + ($BLOCKCHAIN || []).length.to_s
  puts "HOST: #{HOST}"
  puts "My peers: " + $PEERS.sort.join(", ").to_s.yellow
end

def update_blockchain(their_json_blockchain)
  # TODO
  return if their_json_blockchain.nil?
  their_blockchain = BlockChain.new(Message.new(their_json_blockchain.shift['msg']))
  their_json_blockchain.each do |bloch_h|
    their_blockchain.add_to_chain(Message.new(bloch_h['msg']))
  end

  return if $BLOCKCHAIN && their_blockchain.length <= $BLOCKCHAIN.length
  return unless their_blockchain.valid?

  $BLOCKCHAIN = their_blockchain
end

def update_peers(their_peers)
  $PEERS = ($PEERS + their_peers).uniq
end
