# rubocop:disable Style/For
# rubocop:disable Metrics/ModuleLength

module Enumerable
  # Iterates through the object, identical to #each
  def my_each
    for i in self
      yield i
    end
  end

  # Iterates through the object, returning value and index. Identical to #each_with_index
  def my_each_with_index
    i = 0
    while i < length
      yield self[i], i
      i += 1
    end
  end

  # Creates a new array containing the elements of self that match the provided test.
  def my_select
    result = []
    my_each do |i|
      result.push(i) if yield i
    end
    p result
  end

  # Returns true if every value passes a test (defined as a block) or
  # if no block is given returns true if all values are truthy.
  def my_all?
    result = true
    unless block_given?
      my_each do |i|
        result = false unless i
        break unless i
      end
      return result
    end
    my_each do |i|
      result = false unless yield i
      break unless yield i
    end
    result
  end

  # Returns true if any value passes a test defined as a block.
  # If no block is given, it returns true if any value is truthy.
  def my_any?
    result = false
    unless block_given?
      my_each do |i|
        result = true if i
        break if i
      end
      return result
    end
    my_each do |i|
      result = true if yield i
      break if yield i
    end
    result
  end

  # Returns true if none of the values passes a test (defined as a block) or
  # if no block is given returns true if none of the values are truthy.
  def my_none?
    result = true
    unless block_given?
      my_each do |i|
        result = false if i
        break if i
      end
      return result
    end
    my_each do |i|
      result = false if yield i
      break if yield i
    end
    result
  end

  # If no argument and no block is passed returns the number of items in the array.
  # If an argument is passed, but no block is passed, returns the number of items equal to the argument.
  # If a block is passed, but no argument is passed, returns the number of items that pass the test.
  # If an argument and a block are passed returns the number of items equal to the argument and prints a warning.
  def my_count(input = nil)
    count = 0
    if !block_given? && input.nil?
      my_each do
        count += 1
      end
      return count
    end
    unless input.nil?
      my_each do |i|
        count += 1 if i == input
      end
      p 'Use either a block or an argument, Not Both!' if block_given?
      return count
    end
    my_each do |i|
      count += 1 if yield i
    end
    count
  end

  # Returns an array containing the result of the block provided
  # applied to each one of the elements of the array provided as argument.
  def my_map
    result = []
    my_each do |i|
      result.push(yield i)
    end
    result
  end

  # Combines the element in an array applying a binary operation
  # and returns the result in an accumulator variable ("memo")
  # When a block and a symbol is given, it prints an Error message.
  # Either a block or a symbol for a binary operation can be provided.
  # An initial value for memo can be provided.
  # If an initial value is not provided, memo takes the value of the first element in the array.
  def my_inject(memo = nil, sym = nil)
    if block_given? && (!sym.nil? || memo.is_a?(Symbol))
      p 'Wrong input. You can not pass a symbol and a block'
      return nil
    end
    unless memo.nil?
      if memo.is_a? Symbol
        sym = memo
        memo = self[0]
      else
        temp = memo
        check = true
      end
      j = 0
      while j < length - 1
        memo = self[j + 1].public_send(sym, memo)
        j += 1
      end
      memo = temp.public_send(sym, memo) if check
      return memo
    end
    if block_given? && memo.nil?
      memo = self[0]
      j = 0
      while j < length - 1
        memo = yield memo, self[j]
        j += 1
      end
      return memo
    end
    if block_given? && !memo.nil?
      my_each do |i|
        memo = yield memo, i
      end
      memo
    end
  end

  def multiply_els(array)
    array.my_inject(:*)
  end

  # map that accepts procs
  def my_map_proc(input_proc = nil)
    if !input_proc.nil? && !input_proc.is_a?(Proc)
      puts 'Error! Argument must be a Proc'
      return nil
    end
    result = []
    my_each do |i|
      result.push(input_proc.call(i)) if input_proc.is_a?(Proc)
      result.push(yield i) if block_given? && input_proc.nil?
    end
    p result
  end
end

multiply_els([2, 4, 5])

my_proc = proc { |num| num * 2 }

array.my_map_proc(my_proc)

# rubocop:enable Style/For
# rubocop:enable Metrics/ModuleLength
