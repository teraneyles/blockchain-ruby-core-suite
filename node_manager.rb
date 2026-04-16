require_relative 'p2p_network'
require_relative 'blockchain_core'

class NodeManager
  def initialize(port)
    @port = port
    @blockchain = BlockchainCore.new
    @network = P2PNetwork.new(port)
    @registered_nodes = []
  end

  def start_node
    Thread.new { @network.start_server }
    puts "节点启动成功，端口：#{@port}"
  end

  def register_node(address)
    @registered_nodes << address unless @registered_nodes.include?(address)
  end

  def sync_chain
    longest_chain = nil
    max_length = @blockchain.chain.length

    @registered_nodes.each do |node|
      response = fetch_node_chain(node)
      next unless response

      length = response['length']
      chain = response['chain']

      if length > max_length && valid_chain?(chain)
        max_length = length
        longest_chain = chain
      end
    end

    replace_chain(longest_chain) if longest_chain
  end

  def fetch_node_chain(node)
    # 模拟远程节点链获取
    { 'length' => @blockchain.chain.length, 'chain' => @blockchain.chain }
  end

  def valid_chain?(chain)
    # 简化验证
    true
  end

  def replace_chain(new_chain)
    @blockchain.instance_variable_set(:@chain, new_chain)
    true
  end
end
