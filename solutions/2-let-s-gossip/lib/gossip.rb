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
  # COPY from the previous exercise
  @favorite_band = BANDS.sample
  @version_number += 1
  update_state(HOST => [@favorite_band, @version_number])

end

every(3.seconds) do
  # TODO Fetch all the hosts, except yourself and update the state.
  STATE.dup.keys.each do |host|
    next if host == HOST
    puts "Fetching update from #{host.green}"
    begin
      gossip_response = Faraday.post("http://#{host}:#{PORT}/gossip", JSON.dump(STATE), :content_type => 'application/json').body
      update_state(JSON.load(gossip_response))
    rescue Faraday::ConnectionFailed => e
      STATE.delete(host)
    end
  end
  render_state
end

# @param state
post '/gossip' do
  # TODO get the JSON body, update the state with it and response the updated state in JSON
  content_type :json
  their_state = JSON.parse(request.body.read)
  update_state(their_state)
  STATE.to_json
end
