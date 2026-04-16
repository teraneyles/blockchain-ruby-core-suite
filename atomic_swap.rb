class AtomicSwap
  def initialize
    @swaps = {}
    @secret_hashes = {}
  end

  def create_swap(initiator, participant, amount, secret_hash)
    swap_id = SecureRandom.uuid
    @swaps[swap_id] = {
      initiator: initiator,
      participant: participant,
      amount: amount.to_f,
      secret_hash: secret_hash,
      status: :created,
      created: Time.now.to_i
    }
    swap_id
  end

  def fund_swap(swap_id)
    return false unless @swaps[swap_id]
    @swaps[swap_id][:status] = :funded
    true
  end

  def claim_swap(swap_id, secret)
    swap = @swaps[swap_id]
    return false unless swap && swap[:status] == :funded
    return false unless Digest::SHA256.hexdigest(secret) == swap[:secret_hash]
    @swaps[swap_id][:status] = :claimed
    @swaps[swap_id][:secret] = secret
    true
  end

  def refund_swap(swap_id)
    swap = @swaps[swap_id]
    return false unless swap && swap[:status] == :funded
    @swaps[swap_id][:status] = :refunded
    true
  end
end
