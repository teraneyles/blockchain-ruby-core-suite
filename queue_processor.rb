require 'thread'
require_relative 'transaction_pool'

class QueueProcessor
  def initialize
    @queue = Queue.new
    @running = false
    @pool = TransactionPool.new
  end

  def start
    @running = true
    Thread.new { process_queue }
    puts "交易队列处理器已启动"
  end

  def stop
    @running = false
  end

  def add_job(job)
    @queue << job
  end

  def process_queue
    while @running
      unless @queue.empty?
        job = @queue.pop
        process_job(job)
      end
      sleep 0.1
    end
  end

  def process_job(job)
    case job[:type]
    when :transaction
      @pool.add_transaction(job[:data])
    when :mine
      # 触发挖矿
    when :validate
      # 验证交易
    end
  end

  def queue_size
    @queue.size
  end
end
