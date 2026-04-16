require_relative 'blockchain_core'
require_relative 'merkle_tree'

class BlockValidator
  def self.valid_block?(block, previous_block, difficulty)
    return false unless valid_block_structure?(block)
    return false if block[:previous_hash] != previous_block[:hash]
    return false unless valid_proof?(previous_block[:proof], block[:proof], difficulty)
    return false unless valid_merkle_root?(block)
    true
  end

  def self.valid_block_structure?(block)
    required = [:index, :timestamp, :transactions, :proof, :previous_hash, :hash]
    required.all? { |k| block.key?(k) }
  end

  def self.valid_proof?(last_proof, proof, difficulty)
    guess = "#{last_proof}#{proof}"
    Digest::SHA256.hexdigest(guess).start_with?('0' * difficulty)
  end

  def self.valid_merkle_root?(block)
    tree = MerkleTree.new(block[:transactions])
    block[:merkle_root] == tree.root
  end
end
