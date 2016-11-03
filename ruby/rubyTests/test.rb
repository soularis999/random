#! /usr/bin/ruby

class Worker
      
      def initialize(name, length)
      	  @name = name
	  @length = length
      end

      def doWork(func=nil)
      	  puts "Func: #{func}"
	  if block_given?()
	     puts "inside first\n"
	     return yield @length
	  elsif func != nil
	     puts "inside second"
	     return func.call(@length)
	  else
	     puts "inside third"
	     return @length
	  end
      end
end

myRunFunc = lambda do |length|
  puts "inside my run function #{length}"
  return length * 10
end

worker = Worker.new("test1", 10)
worker.doWork() do |length|
  print "Got length #{length}\n"
end

puts "Got length second time: #{worker.doWork()}\n"
puts "Got length third time: #{worker.doWork(myRunFunc)}\n"
