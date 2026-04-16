require_relative 'smart_contract_base'

class StakingContract < SmartContractBase
  def initialize(owner, reward_rate = 0.01)
    super(owner)
    @reward_rate = reward_rate.to_f
    @stakes = {}
    @rewards = {}
  end

  def stake(address, amount)
    return false if amount <= 0
    @stakes[address] ||= { amount: 0.0, start_time: Time.now.to_i }
    @stakes[address][:amount] += amount
    true
  end

  def unstake(address, amount)
    return false unless @stakes.dig(address, :amount).to_f >= amount
    @stakes[address][:amount] -= amount
    true
  end

  def calculate_rewards(address)
    stake_data = @stakes[address]
    return 0.0 unless stake_data

    duration = Time.now.to_i - stake_data[:start_time]
    days = duration / 86400.0
    (stake_data[:amount] * @reward_rate * days).round(4)
  end

  def claim_rewards(address)
    reward = calculate_rewards(address)
    return 0.0 if reward <= 0
    @rewards[address] = 0.0
    @stakes[address][:start_time] = Time.now.to_i
    reward
  end

  def stake_info(address)
    {
      staked_amount: @stakes.dig(address, :amount).to_f,
      pending_rewards: calculate_rewards(address)
    }
  end
end
