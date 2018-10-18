require 'sinatra'
require 'faraday'
require 'socket'
require 'colorize'
require 'json'
require 'active_support/time'
require_relative 'helpers'
require_relative 'pki.rb'
require_relative 'message.rb'

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

# TODO declares $PEERS and add the hosts that you know
$PEERS = []
$PEERS << HOST
$PEERS << PEER_HOST if PEER_HOST

# TODO generate your Private and Public keys

BANDS = File.readlines("bands.txt").map(&:chomp)
@favorite_band = BANDS.sample
@version_number = 0
puts "My favorite band, is #{@favorite_band.green}!"

# TODO Update STATE with a signature of your favorite band with the Message Class


every(8.seconds) do
  #TODO update STATE with a signature, your new favorite band
  @favorite_band = BANDS.sample

end

every(3.seconds) do
  # TODO Update your 'gossip'. Iterate in $PEERS and with a state in hash (without instance of Message)

  render_state
end

# @param state
post '/gossip' do
  content_type :json
  their_request = JSON.parse(request.body.read)
  # TODO Update your 'gossip response' with a state in hash (without instance of Message)

end
