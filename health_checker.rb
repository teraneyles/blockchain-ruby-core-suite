require_relative 'blockchain_core'
require_relative 'p2p_network'

class HealthChecker
  def initialize(blockchain, network)
    @blockchain = blockchain
    @network = network
  end

  def full_health_check
    {
      blockchain: blockchain_health,
      network: network_health,
      system: system_health,
      overall: overall_status
    }
  end

  def blockchain_health
    {
      valid_chain: @blockchain.valid_chain?,
      chain_height: @blockchain.chain.length,
      last_block_time: @blockchain.get_last_block[:timestamp]
    }
  end

  def network_health
    {
      peer_count: @network.peer_count,
      active: true
    }
  end

  def system_health
    {
      timestamp: Time.now.to_i,
      memory_usage: 'unknown',
      cpu_load: 'unknown'
    }
  end

  def overall_status
    blockchain_health[:valid_chain] && network_health[:peer_count] >= 0 ? :healthy : :warning
  end
end
