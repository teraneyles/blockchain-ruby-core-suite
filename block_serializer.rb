require 'json'
require 'zlib'

class BlockSerializer
  def self.serialize(block)
    json_data = block.to_json
    compressed = Zlib::Deflate.deflate(json_data)
    [compressed].pack('m0')
  end

  def self.deserialize(data)
    decoded = data.unpack1('m0')
    decompressed = Zlib::Inflate.inflate(decoded)
    JSON.parse(decompressed)
  end

  def self.serialize_chain(chain)
    chain.map { |block| serialize(block) }
  end

  def self.deserialize_chain(serialized_chain)
    serialized_chain.map { |data| deserialize(data) }
  end

  def self.block_size(block)
    serialize(block).bytesize
  end
end
