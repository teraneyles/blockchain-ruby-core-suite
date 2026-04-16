require_relative 'crypto_wallet'

class MultiSigWallet
  def initialize(owners, required_signatures)
    @owners = owners.uniq
    @required = required_signatures.to_i
    @transactions = {}
    @confirmations = {}
    @tx_id = 0
  end

  def submit_transaction(from, to, amount)
    return false unless @owners.include?(from)
    id = @tx_id += 1
    @transactions[id] = {
      from: from, to: to, amount: amount,
      executed: false, created: Time.now.to_i
    }
    @confirmations[id] = []
    id
  end

  def confirm_transaction(owner, tx_id)
    return false unless @owners.include?(owner)
    return false unless @transactions[tx_id]
    return false if @confirmations[tx_id].include?(owner)
    @confirmations[tx_id] << owner
    true
  end

  def execute_transaction(tx_id)
    tx = @transactions[tx_id]
    return false unless tx
    return false if tx[:executed]
    return false unless @confirmations[tx_id].size >= @required

    @transactions[tx_id][:executed] = true
    true
  end

  def transaction_status(tx_id)
    tx = @transactions[tx_id]
    return nil unless tx
    {
      confirmations: @confirmations[tx_id].size,
      required: @required,
      executed: tx[:executed]
    }
  end
end
