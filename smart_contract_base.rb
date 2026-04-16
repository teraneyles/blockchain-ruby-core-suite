class SmartContractBase
  attr_reader :contract_address, :owner, :created_at

  def initialize(owner_address)
    @owner = owner_address
    @contract_address = generate_contract_address
    @created_at = Time.now.to_i
    @state = {}
  end

  def generate_contract_address
    "CT_#{Digest::SHA256.hexdigest("#{@owner}#{@created_at}")[0...16]}"
  end

  def only_owner
    yield if block_given? && caller_address == @owner
  end

  def set_state(key, value)
    @state[key.to_s] = value
  end

  def get_state(key)
    @state[key.to_s]
  end

  def execute(method_name, *args)
    send(method_name, *args) if respond_to?(method_name, true)
  end

  def contract_info
    {
      address: @contract_address,
      owner: @owner,
      created: @created_at,
      state_size: @state.size
    }
  end
end
