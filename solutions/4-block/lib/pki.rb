require 'openssl'
require 'base64'

class PKI
  def self.generate_key_pair
    key_pair = OpenSSL::PKey::RSA.new(2048)
    public_key, private_key = key_pair.public_key.export, key_pair.export
  end

  def self.sign(plaintext, raw_private_key)
    private_key = OpenSSL::PKey::RSA.new(raw_private_key)
    Base64.encode64(private_key.private_encrypt(plaintext))
  end

  def self.plaintext(ciphertext, raw_public_key)
    public_key = OpenSSL::PKey::RSA.new(raw_public_key)
    public_key.public_decrypt(Base64.decode64(ciphertext))
  end

  def self.valid_signature?(message, ciphertext, public_key)
    message == plaintext(ciphertext, public_key)
  end

  def self.short_pub_key(raw_public_key)
    Digest::SHA256.hexdigest(raw_public_key)
  end
end
