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

# TODO generate Private and Public keys
MY_PUBLIC_KEY, MY_PRIVATE_KEY = PKI.generate_key_pair

BANDS = File.readlines("bands.txt").map(&:chomp)
@favorite_band = BANDS.sample
@version_number = 0
puts "My favorite band, is #{@favorite_band.green}!"

# Update STATE with a signature of your favorite band with the version_number
update_state(MY_PUBLIC_KEY => Message.new({'content' => @favorite_band, 'from' => MY_PUBLIC_KEY, 'priv_key' => MY_PRIVATE_KEY}))

every(8.seconds) do
  #TODO update STATE with a signature of your favorite band
  @favorite_band = BANDS.sample
  @version_number += 0
  update_state(MY_PUBLIC_KEY => Message.new({'content' => @favorite_band, 'from' => MY_PUBLIC_KEY, 'priv_key' => MY_PRIVATE_KEY}))
end

every(3.seconds) do
  # TODO Fetch all the hosts, except yourself and update the state.
  $PEERS.dup.each do |host|
    next if host == HOST
    puts "Fetching update from #{host.green}"
    begin
      gossip_response = JSON.load(Faraday.post("http://#{host}:#{PORT}/gossip", JSON.dump({ state: state_hash, peers: $PEERS }), :content_type => 'application/json').body)
      update_state(gossip_response['state'])
      update_peers(gossip_response['peers'])
    rescue Faraday::ConnectionFailed => e
      $PEERS.delete(host)
    end
  end
  render_state
end

# @param state
post '/gossip' do
  # TODO get the JSON body, update the state and the peers with it and response the updated state and peers in JSON
  content_type :json
  their_request = JSON.parse(request.body.read)
  update_state(their_request['state'])
  update_peers(their_request['peers'])
  { state: state_hash, peers: $PEERS }.to_json
end
