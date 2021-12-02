commands = File.read('input02.txt').split("\n").map { |command| command.split(' ') }

position = 0
depth = 0
aim = 0
commands.each do |action, x|
  x = x.to_i

  case action
  when "forward"
    position += x
    depth += aim * x
  when "down"
    aim += x
  when "up"
    aim -= x
  end
end

pp position * depth
