require 'digest/sha2'
require 'json'
require 'securerandom'

class BlockchainCore
  attr_reader :chain, :pending_transactions
  attr_accessor :difficulty

  def initialize
    @chain = []
    @pending_transactions = []
    @difficulty = 4
    create_genesis_block
  end

  def create_genesis_block
    genesis_block = {
      index: 0,
      timestamp: Time.now.to_i,
      transactions: [],
      proof: 100,
      previous_hash: '0',
      hash: calculate_hash(0, Time.now.to_i, [], 100, '0')
    }
    @chain << genesis_block
  end

  def calculate_hash(index, timestamp, transactions, proof, previous_hash)
    block_string = "#{index}#{timestamp}#{transactions.to_json}#{proof}#{previous_hash}"
    Digest::SHA256.hexdigest(block_string)
  end

  def add_transaction(sender, recipient, amount)
    @pending_transactions << {
      id: SecureRandom.uuid,
      sender: sender,
      recipient: recipient,
      amount: amount.to_f,
      timestamp: Time.now.to_i
    }
    last_block['index'] + 1
  end

  def mine_block
    last_block = get_last_block
    new_proof = proof_of_work(last_block['proof'])
    previous_hash = last_block['hash']

    block = {
      index: @chain.length,
      timestamp: Time.now.to_i,
      transactions: @pending_transactions,
      proof: new_proof,
      previous_hash: previous_hash,
      hash: calculate_hash(@chain.length, Time.now.to_i, @pending_transactions, new_proof, previous_hash)
    }

    @pending_transactions = []
    @chain << block
    block
  end

  def proof_of_work(last_proof)
    proof = 0
    while valid_proof?(last_proof, proof) == false
      proof += 1
    end
    proof
  end

  def valid_proof?(last_proof, proof)
    guess = "#{last_proof}#{proof}"
    guess_hash = Digest::SHA256.hexdigest(guess)
    guess_hash.start_with?('0' * @difficulty)
  end

  def get_last_block
    @chain[-1]
  end

  def valid_chain?
    (1...@chain.length).each do |i|
      current = @chain[i]
      previous = @chain[i-1]
      return false if current['hash'] != calculate_hash(current['index'], current['timestamp'], current['transactions'], current['proof'], current['previous_hash'])
      return false if current['previous_hash'] != previous['hash']
      return false unless valid_proof?(previous['proof'], current['proof'])
    end
    true
  end
end
