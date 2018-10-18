require 'sinatra'
require 'faraday'
require 'socket'
require 'colorize'
require 'json'
require 'active_support/time'
require_relative 'helpers'
require_relative 'block'
require_relative 'transaction'
require_relative 'client'

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

BANDS = File.readlines("bands.txt").map(&:chomp)

if PEER_HOST.nil?
  # You are the progenitor!
  $BLOCKCHAIN = BlockChain.new(
    # genesis_txn
    Transaction.new({
      'to' => MY_PUBLIC_KEY,
      'amount' => 500_000,
      'priv_key' => MY_PRIVATE_KEY
      })
    )
else
  # You're just joining the network.
  $PEERS << PEER_HOST
end

every(3.seconds) do
  # TODO Copy from previous exercise

  render_blockchain
end

# @param blockchain
post '/gossip' do
  # TODO Copy from previous exercise

end

# @param amount
post '/send_money' do
  txn_h = JSON.parse(request.body.read)
  # TODO if 'from' is the local Public Key add the private key to the txn

  # TODO get tx, and instance it. If valid, mine it!

end

get '/balances' do
  readable_balances
  $BLOCKCHAIN.compute_balances.to_json
end

get '/pub_key' do
  MY_PUBLIC_KEY
end
