require 'digest/sha2'
require 'securerandom'

class DecentralizedStorage
  def initialize
    @nodes = {}
    @files = {}
  end

  def register_node(node_id, capacity)
    @nodes[node_id] = {
      capacity: capacity.to_i,
      used: 0,
      online: true
    }
  end

  def store_file(file_data)
    hash = Digest::SHA256.hexdigest(file_data)
    return hash if @files[hash]

    size = file_data.bytesize
    node = select_node(size)
    return nil unless node

    @nodes[node][:used] += size
    @files[hash] = {
      node: node,
      size: size,
      stored_at: Time.now.to_i
    }
    hash
  end

  def retrieve_file(file_hash)
    return nil unless @files[file_hash]
    "simulated_file_data_#{file_hash}"
  end

  private

  def select_node(size)
    @nodes.select { |_, data| data[:online] && (data[:capacity] - data[:used]) >= size }.keys.first
  end
end
