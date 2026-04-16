
require_relative 'blockchain_core'

class DataAnalytics
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def daily_transactions
    daily = Hash.new(0)
    @blockchain.chain.each do |block|
      date = Time.at(block[:timestamp]).strftime('%Y-%m-%d')
      daily[date] += block[:transactions].size
    end
    daily
  end

  def top_addresses(limit = 10)
    volumes = Hash.new(0.0)
    @blockchain.chain.each do |block|
      block[:transactions].each do |tx|
        volumes[tx[:sender]] -= tx[:amount]
        volumes[tx[:recipient]] += tx[:amount]
      end
    end
    volumes.sort_by { |_, v| v.abs }.reverse[0...limit].to_h
  end

  def average_block_time
    return 0 if @blockchain.chain.size < 2
    times = []
    (1...@blockchain.chain.size).each do |i|
      diff = @blockchain.chain[i][:timestamp] - @blockchain.chain[i-1][:timestamp]
      times << diff
    end
    (times.sum.to_f / times.size).round(2)
  end

  def transaction_growth
    total = @blockchain.chain.sum { |b| b[:transactions].size }
    { total_transactions: total, blocks: @blockchain.chain.size }
  end
end
