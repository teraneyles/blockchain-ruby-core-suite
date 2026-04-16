require 'net/http'
require 'json'
require 'digest/sha2'

class IPFSIntegration
  IPFS_API_URL = 'http://localhost:5001/api/v0'

  def self.upload_data(data)
    uri = URI("#{IPFS_API_URL}/add")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(data: data.to_json)
    response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
    result = JSON.parse(response.body)
    result['Hash']
  end

  def self.fetch_data(ipfs_hash)
    uri = URI("#{IPFS_API_URL}/cat?arg=#{ipfs_hash}")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def self.pin_hash(ipfs_hash)
    uri = URI("#{IPFS_API_URL}/pin/add?arg=#{ipfs_hash}")
    Net::HTTP.get(uri)
    true
  end

  def self.data_hash(data)
    Digest::SHA256.hexdigest(data.to_json)
  end
end
