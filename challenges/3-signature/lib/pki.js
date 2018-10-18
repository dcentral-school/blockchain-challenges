const { generateKeyPairSync, createSign } = require('crypto');

function generateKeyPairRSA() {
  return Object.values(generateKeyPairSync('rsa', {
    modulusLength: 2048,
    publicKeyEncoding: {
      type: 'pkcs1',
      format: 'pem'
    },
    privateKeyEncoding: {
      type: 'pkcs1'
      format: 'pem'
    }
  }));
}


function sign(plaintext, raw_private_key) {
  const signature = createSign('RSA-SHA256');
  signature.write(plaintext);
  signature.end();
  // private_key = OpenSSL::PKey::RSA.new(raw_private_key)
  return signature.sign(raw_private_key, 'base64');
}
//
// def plaintext(ciphertext, raw_public_key)
//   public_key = OpenSSL::PKey::RSA.new(raw_public_key)
//   public_key.public_decrypt(Base64.decode64(ciphertext))
// end
//
// def valid_signature?(message, ciphertext, public_key)
//   message == plaintext(ciphertext, public_key)
// end

module.exports = { generateKeyPairRSA, sign }
