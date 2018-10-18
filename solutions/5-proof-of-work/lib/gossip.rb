require 'sinatra'
require 'faraday'
require 'socket'
require 'colorize'
require 'json'
require 'active_support/time'
require_relative 'helpers'
require_relative 'block'
require_relative 'message'

# Set same PORT for everyone in Sinatra
PORT = 1111
set :port, PORT
set :bind, '0.0.0.0'

# Get your local private IP
addr_infos = Socket.ip_address_list
HOST = addr_infos.find(&:ipv4_private?).ip_address

# Get the first peer from the command line
PEER_HOST = ARGV.first


# Declare the State hash and set first values
STATE = ThreadSafe::Hash.new

$PEERS = []
$PEERS << HOST

# TODO generate Private and Public keys
MY_PUBLIC_KEY, MY_PRIVATE_KEY = PKI.generate_key_pair

if PEER_HOST.nil?
  # You are the progenitor!
  $BLOCKCHAIN = BlockChain.new(Message.new({'content' => "", 'from' => MY_PUBLIC_KEY, 'priv_key' => MY_PRIVATE_KEY}))
else
  # You're just joining the network.
  $PEERS << PEER_HOST
end

every(3.seconds) do
  # TODO Fetch all the hosts, except yourself and update the blockchain.
  $PEERS.dup.each do |host|
    next if host == HOST
    puts "Fetching update from #{host.green}"
    begin
      blockchain_a = $BLOCKCHAIN && $BLOCKCHAIN.to_a_of_h
      gossip_response = JSON.load(Faraday.post("http://#{host}:#{PORT}/gossip", JSON.dump({ blockchain: blockchain_a, peers: $PEERS }), :content_type => 'application/json').body)
      update_blockchain(gossip_response['blockchain'])
      update_peers(gossip_response['peers'])
    rescue Faraday::ConnectionFailed => e
      $PEERS.delete(host)
    end
  end
  render_blockchain
end

# @param blockchain
post '/gossip' do
  # TODO get the JSON body, update the blockchain and the peers with it and response the updated blockchain and peers in JSON
  content_type :json
  their_request = JSON.parse(request.body.read)
  update_blockchain(their_request['blockchain'])
  update_peers(their_request['peers'])
  blockchain_a = $BLOCKCHAIN && $BLOCKCHAIN.to_a_of_h
  { blockchain: blockchain_a, peers: $PEERS }.to_json
end

# @param favorite_band
post '/send_message' do
  # TODO get message, and instance it. If valid, mine it!
  msg_h = JSON.parse(request.body.read)
  message =  Message.new(msg_h)
  if message.is_valid_signature?
    $BLOCKCHAIN.add_to_chain(message)
    'OK. Block mined!'
  else
    'Uncorrect signature'
  end
end
