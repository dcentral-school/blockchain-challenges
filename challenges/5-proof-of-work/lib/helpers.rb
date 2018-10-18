require_relative 'pki.rb'

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
  # TODO Copy from previous exercise
end

def update_peers(their_peers)
  $PEERS = ($PEERS + their_peers).uniq
end
