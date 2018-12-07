require 'set'

class Task
  attr_reader :duration, :name
  attr_accessor :start_time

  def initialize(task)
    @name = task
    @duration = 60 + task.ord - 'A'.ord
  end

  def end_time
    start_time + duration
  end
end

class WorkerManager
  attr_accessor :clock
  attr_reader :q

  def initialize(workers)
    @workers = Array.new(workers) { Worker.new }

    @q = []
    @task_to_worker = {}

    @clock = 0
  end

  def work(task)
    q << task
  end

  def tick
    q.reject! { |task| completed?(task) }
    if available?
      q.take(workers.size).reject { |task| assigned?(task) }.each do |task|
        task.start_time = clock
        task_to_worker[task] = first_available
        task_to_worker[task].work(task)
      end
    end
    workers.each(&:tick)

    self.clock += 1
  end

  def completed?(task)
    assigned?(task) && task_to_worker[task].available?
  end

  def idle?
    q.empty?
  end

  def full?
    q.reject! { |task| completed?(task) }
    q.size == workers.size
  end

  def available?
    !first_available.nil?
  end

  private

  attr_reader :start_time, :task_to_worker, :workers

  def assigned?(task)
    task_to_worker.key?(task)
  end

  def first_available
    workers.find(&:available?)
  end
end

class Worker
  attr_accessor :remaining_time

  def initialize
    @remaining_time = 0
  end

  def work(task)
    self.remaining_time = task.duration
  end

  def tick
    return if available?

    self.remaining_time -= 1
  end

  def available?
    remaining_time == 0
  end
end

class Graph
  def initialize(edges, workers)
    @edges = edges
    @worker_manager = WorkerManager.new(workers)
  end

  def topo_sort
    q = SortedSet.new(roots)
    while !q.empty? || !worker_manager.q.empty?
      pool = q.select do |node|
        incoming[node].all? do |src|
          worker_manager.completed?(tasks[src])
        end
      end

      while !worker_manager.full? && !q.empty?
        break if pool.empty?

        worker_manager.work(tasks[pool.first])
        q.delete(pool.first)
        pool.shift
      end

      worker_manager.tick

      completed_nodes = nodes.select do |node|
        worker_manager.q.include?(tasks[node]) && worker_manager.completed?(tasks[node])
      end

      completed_nodes.each do |node|
        q += outgoing[node]
      end
    end

    tasks.values.map(&:end_time).max
  end

  private

  attr_reader :edges, :end_times, :visited, :worker_manager

  def roots
    @roots ||= nodes.select { |node| incoming[node].empty? }
  end

  def incoming
    @incoming ||= edges.reduce(Hash.new { |h, k| h[k] = Set.new }) do |acc, edge|
      acc[edge.trg] << edge.src
      acc
    end
  end

  def outgoing
    @outgoing ||= edges.sort.reduce(Hash.new { |h, k| h[k] = [] }) do |acc, edge|
      acc[edge.src] << edge.trg
      acc
    end
  end

  def nodes
    @nodes ||= edges.reduce([]) do |acc, edge|
      acc << edge.src
      acc << edge.trg
      acc
    end.uniq.sort
  end

  def tasks
    @tasks ||= nodes.reduce({}) do |acc, node|
      acc[node] = Task.new(node)
      acc
    end
  end
end

class Edge
  attr_reader :src, :trg

  def initialize(src, trg)
    @src = src
    @trg = trg
  end

  def <=>(other)
    return trg <=> other.trg if src == other.src

    src <=> other.src
  end
end

edges = File.read('input07.txt').split("\n").map do |edge|
  Edge.new(*/^\w+ (\w).+(\w) \w+ \w+\.$/.match(edge).to_a.drop(1))
end

graph = Graph.new(edges, 5)
puts graph.topo_sort + 1
