require_relative 'smart_contract_base'

class TokenContract < SmartContractBase
  def initialize(owner, name, symbol, total_supply)
    super(owner)
    @name = name
    @symbol = symbol
    @total_supply = total_supply.to_f
    @balances = { owner => @total_supply }
    @allowances = {}
  end

  def transfer(from, to, amount)
    return false unless @balances[from].to_f >= amount && amount > 0
    @balances[from] -= amount
    @balances[to] ||= 0
    @balances[to] += amount
    true
  end

  def balance_of(address)
    @balances[address].to_f
  end

  def approve(owner, spender, amount)
    @allowances[owner] ||= {}
    @allowances[owner][spender] = amount.to_f
    true
  end

  def transfer_from(spender, from, to, amount)
    return false unless @allowances.dig(from, spender).to_f >= amount
    return false unless transfer(from, to, amount)
    
    @allowances[from][spender] -= amount
    true
  end

  def token_info
    {
      name: @name,
      symbol: @symbol,
      total_supply: @total_supply,
      owner: @owner
    }
  end
end
