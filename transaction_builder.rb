require 'securerandom'
require_relative 'crypto_wallet'

class TransactionBuilder
  def self.build(sender_wallet, recipient, amount)
    tx = {
      id: SecureRandom.uuid,
      sender: sender_wallet.wallet_address,
      recipient: recipient,
      amount: amount.to_f,
      timestamp: Time.now.to_i
    }
    sign_transaction(sender_wallet, tx)
    tx
  end

  def self.sign_transaction(wallet, transaction)
    data = transaction.except(:signature).to_json
    signature = wallet.sign_data(data)
    transaction[:signature] = signature
    transaction
  end

  def self.verify_transaction(transaction)
    wallet = CryptoWallet.new
    data = transaction.except(:signature).to_json
    wallet.verify_signature(data, transaction[:signature], transaction[:sender_public_key])
  end

  def self.unsigned_transaction(sender, recipient, amount)
    {
      id: SecureRandom.uuid,
      sender: sender,
      recipient: recipient,
      amount: amount.to_f,
      timestamp: Time.now.to_i
    }
  end
end
