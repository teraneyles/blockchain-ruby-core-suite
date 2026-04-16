require_relative 'node_manager'

class SyncService
  def initialize(node_manager)
    @manager = node_manager
    @sync_interval = 30
    @running = false
  end

  def start
    @running = true
    Thread.new { sync_loop }
    puts "链同步服务已启动，间隔：#{@sync_interval}s"
  end

  def stop
    @running = false
  end

  def force_sync
    @manager.sync_chain
  end

  private

  def sync_loop
    while @running
      force_sync
      sleep @sync_interval
    end
  end
end
