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


$PEERS = []
$PEERS << HOST

# TODO generate Private and Public keys
MY_PUBLIC_KEY, MY_PRIVATE_KEY = PKI.generate_key_pair

BANDS = File.readlines("bands.txt").map(&:chomp)
@favorite_band = BANDS.sample
puts "My favorite band, is #{@favorite_band.green}!"

if PEER_HOST.nil?
  # You are the progenitor!
  # TODO create the instance of the BlockChain with a first message
else
  # You're just joining the network.
  $PEERS << PEER_HOST
end

every(8.seconds) do
  @favorite_band = BANDS.sample
  #TODO Add your new favorite band to the BlockChain

end

every(3.seconds) do
  # TODO Update your 'gossip'. Send the blockchain instead of a state.
  # Be careful to send a blockchain in array of hashes. Update the BlockChain with
  # the one received.

  render_blockchain
end

# @param blockchain
post '/gossip' do
  # TODO Update the BlockChain with the one received.
  content_type :json
  their_request = JSON.parse(request.body.read)
  update_blockchain(their_request['blockchain'])
  update_peers(their_request['peers'])
  blockchain_a = $BLOCKCHAIN && $BLOCKCHAIN.to_a_of_h
  { blockchain: blockchain_a, peers: $PEERS }.to_json
end
