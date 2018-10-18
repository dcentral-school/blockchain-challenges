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

def render_state
  puts "-" * 40
  STATE.to_a.sort_by(&:first).each do |pub_key, msg|
    # TODO Use a short version of the public key
    puts "#{PKI.short_pub_key(msg.from).green} currently likes #{msg.content.yellow}"
  end
  puts "-" * 40
end

def state_hash
  STATE.map { |k, msg| [k, msg.to_h] }.to_h
end

def update_state(update)
  update.each do |pub_key, msg|
    next if pub_key.nil?
    # TODO verify if the signature is correct
    msg = Message.new(msg) unless msg.is_a?(Message)
    next unless msg.is_valid_signature?
    STATE[pub_key] = msg
  end
end

def update_peers(their_peers)
  $PEERS = ($PEERS + their_peers).uniq
end
