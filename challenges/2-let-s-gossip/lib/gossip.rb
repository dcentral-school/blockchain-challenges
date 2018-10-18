require 'sinatra'
require 'faraday'
require 'socket'
require 'colorize'
require 'json'
require 'active_support/time'
require_relative 'helpers'

# Set same PORT for everyone in Sinatra
PORT = 1111
set :port, PORT
set :bind, '0.0.0.0'

# Get your local private IP
addr_infos = Socket.ip_address_list
HOST = addr_infos.find(&:ipv4_private?).ip_address

# Get the first peer from the command line
PEER_HOST = ARGV.first || HOST


# Declare the State hash and set first values
STATE = ThreadSafe::Hash.new
update_state(HOST => nil)
update_state(PEER_HOST => nil)

BANDS = File.readlines("bands.txt").map(&:chomp)
@favorite_band = BANDS.sample
@version_number = 0
puts "My favorite band, is #{@favorite_band.green}!"

update_state(HOST => [@favorite_band, @version_number])

every(8.seconds) do
  # TODO COPY from the previous exercise

end

every(3.seconds) do
  # TODO Fetch all the hosts, except yourself and update the state.

  render_state
end

# @param state
post '/gossip' do
  content_type :json
  their_request = JSON.parse(request.body.read)
  # TODO get the JSON body, update the state with it and response the updated state in JSON

end
