require 'socket'
require 'colorize'
require 'active_support/time'
require_relative 'helpers'

# Get your local private IP
addr_infos = Socket.ip_address_list
HOST = addr_infos.find(&:ipv4_private?).ip_address

# Declare the State hash and set first value
STATE = ThreadSafe::Hash.new
update_state(HOST => nil)

BANDS = File.readlines("bands.txt").map(&:chomp)
@favorite_band = BANDS.sample
@version_number = 0
puts "My favorite band, is #{@favorite_band.green}!"

update_state(HOST => [@favorite_band, @version_number])

every(8.seconds) do
  # TODO
  # Every 8 seconds change your own state to a new favorite band (don't forget to print something fun on the terminal)

end

every(3.seconds) do
  render_state
end
