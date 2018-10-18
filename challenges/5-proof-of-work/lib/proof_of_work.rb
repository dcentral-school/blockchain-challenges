require 'digest'

NUM_ZEROES = 2

def hash(message)
  Digest::SHA256.hexdigest(message)
end

def find_nonce(message, difficulty)
  nonce = 0
  until is_valid_nonce?(nonce, message, difficulty)
    print "." if nonce % 100_000 == 0
    nonce = nonce.next
  end
  puts nonce
  nonce
end

def is_valid_nonce?(nonce, message, difficulty = NUM_ZEROES)
  hash(message + nonce.to_s).start_with?("0" * difficulty)
end

# require 'benchmark'
# Benchmark.measure { find_nonce('coucou', 5) }.total
