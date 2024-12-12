# frozen_string_literal: true

class Block
  attr_reader :id

  def initialize(id: -1)
    @id = id
  end

  def free?
    @id == -1
  end
end

class Disk
  def initialize(map)
    expand(map)
  end

  def expand(map)
    @blocks = []
    @file_blocks = {}

    id = 0

    free_block = Block.new(id: -1)

    map.each_slice(2) do |file_size, free_size|
      file_block = Block.new(id: id)

      @file_blocks[id] = (0...file_size).map { |i| i + @blocks.size }
      @blocks.concat(Array.new(file_size, file_block))
      @blocks.concat(Array.new(free_size, free_block))

      id += 1
    end

    @max_id = id - 1
  end

  def output
    (0...@blocks.size).each do |i|
      if @blocks[i].free?
        print '.'
      else
        print @blocks[i].id
      end
    end
    puts
  end

  def left_most_free_index
    (0...@blocks.size).each do |i|
      return i if @blocks[i].free?
    end

    -1
  end

  def right_most_file_index
    (0...@blocks.size).reverse_each do |i|
      return i if !@blocks[i].free?
    end

    -1
  end

  def swap(a, b)
    tmp = @blocks[a]
    @blocks[a] = @blocks[b]
    @blocks[b] = tmp
  end

  def rotate
    left = left_most_free_index
    right = right_most_file_index

    return false if left == -1 || right == -1 || right <= left

    swap(left, right)

    true
  end

  def defrag
    while rotate
    end
  end

  def left_most_free_group(min_size:)
    @blocks.each_cons(min_size).with_index do |partition, index|
      return index if partition.all?(&:free?)
    end

    -1
  end

  def defrag_whole
    id = @max_id
    while id >= 0
      file_size = @file_blocks[id].size
      free_group_index = left_most_free_group(min_size: file_size)

      if free_group_index != -1 && free_group_index < @file_blocks[id].first
        @file_blocks[id].each_with_index do |block_pos, index|
          swap(block_pos, free_group_index + index)
        end
      end

      id -= 1
    end
  end

  def checksum
    (0...@blocks.size).sum do |i|
      next 0 if @blocks[i].free?

      @blocks[i].id * i
    end
  end
end

def solution
  map = File.read('input09.txt').each_char.map(&:to_i)
  disk = Disk.new(map)

  # disk.defrag # Part 1
  disk.defrag_whole # Part 2

  disk.checksum
end

pp solution
