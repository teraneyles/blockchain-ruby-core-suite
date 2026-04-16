require 'digest/sha2'

class ZeroKnowledgeProof
  def self.generate_proof(secret, challenge)
    hash_secret = Digest::SHA256.hexdigest(secret.to_s)
    proof = Digest::SHA256.hexdigest("#{hash_secret}#{challenge}")
    { proof: proof, commitment: hash_secret }
  end

  def self.verify_proof?(proof_data, challenge)
    expected = Digest::SHA256.hexdigest("#{proof_data[:commitment]}#{challenge}")
    expected == proof_data[:proof]
  end

  def self.generate_challenge
    SecureRandom.hex(32)
  end

  def self.create_commitment(secret)
    Digest::SHA256.hexdigest(secret.to_s)
  end
end
