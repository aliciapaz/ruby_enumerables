# rubocop:disable Style/For
# rubocop:disable Metrics/ModuleLength

module Enumerable

  # Iterates through the object, identical to #each
  def my_each
    return enum_for(:each) unless block_given? # returns an Enumerator when no block is given
    for i in self
      yield i
    end
  end

  # Iterates through the object, returning value and index. Identical to #each_with_index
  def my_each_with_index
    return enum_for(:each) unless block_given? # returns an Enumerator when no block is given
    j = 0
    for i in self do
        yield i, j
        j += 1
    end
    self
  end

  # Creates a new array containing the elements of self that match the provided test.
  def my_select
    return enum_for(:each) unless block_given? # returns an Enumerator when no block is given
    result = []
    my_each do |i|
      result.push(i) if yield i
    end
    result
  end

  # Returns true if every value passes a test (defined as a block) or
  # if no block is given returns true if all values are truthy.
  def my_all?(input = nil)
      result = true
      each do |i|
          if input.class == Class && !((i).is_a?(input))
              result = false
              break
          elsif !block_given? && !i
              result = false
              break
          elsif block_given? && !yield(i)
              result = false
              break
          end
      end
      return result
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
    return enum_for(:each) unless block_given? # returns an Enumerator when no block is given
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
    if memo.is_a? Symbol
      sym = memo
      memo = nil
    end
    init_sym = self[0]
    init_block = self[0]
    j = 1
    while j < length
      init_sym = self[j].public_send(sym, init_sym) unless sym.nil?
      init_block = yield init_block, self[j] if block_given?
      j += 1
    end
    init_sym = init_sym.public_send(sym, memo) unless memo.nil? || sym.nil?
    init_block = yield init_block, memo unless memo.nil? || !block_given?
    return init_sym unless sym.nil?
    return init_block if block_given?
  end
end

def multiply_els(array)
  array.my_inject(:*)
end

# map that accepts procs
def my_map_proc(input_proc = nil)
  return enum_for(:each) if input_proc.nil? && !block_given? # returns an Enumerator when no block nor proc are given
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

multiply_els([2, 4, 5])


# rubocop:enable Style/For
# rubocop:enable Metrics/ModuleLength
