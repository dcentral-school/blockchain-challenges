require_relative 'pki.rb'
require_relative 'transaction.rb'

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

def readable_balances
  return "" if $BLOCKCHAIN.nil?
  $BLOCKCHAIN.compute_balances.each do |pub_key, balance|
     puts "#{PKI.short_pub_key(pub_key).red} currently has #{balance.to_s.green} \n"
  end
end

def update_blockchain(their_json_blockchain)
  # TODO Update from the previous exercise replacing the messages by transactions

end

def update_peers(their_peers)
  $PEERS = ($PEERS + their_peers).uniq
end
