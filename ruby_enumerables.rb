# rubocop:disable Style/For
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Style/GuardClause
# rubocop:disable Metrics/AbcSize
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
    check = true
    each do |i|
      check = if block_given?
                yield i
              elsif input.instance_of?(Class) || input.is_a?(Module)
                i.is_a?(input)
              elsif input.is_a?(Regexp)
                input.match?(i)
              elsif input.nil?
                i
              else
                i == input
              end
      result = false unless check
      break unless result
    end
    result
  end

  # Returns true if any value passes a test defined as a block.
  # If no block is given, it returns true if any value is truthy.
  def my_any?(input = nil)
    result = false
    check = false
    each do |i|
      check = if block_given?
                yield i
              elsif input.instance_of?(Class) || input.is_a?(Module)
                i.is_a?(input)
              elsif input.is_a?(Regexp)
                input.match?(i)
              elsif input.nil?
                i
              else
                i == input
              end
      result = true if check
      break if result
    end
    result
  end

  # Returns true if none of the values passes a test (defined as a block) or
  # if no block is given returns true if none of the values are truthy.
  def my_none?(input = nil)
    result = true
    check = true
    each do |i|
      check = if block_given?
                yield i
              elsif input.instance_of?(Class) || input.is_a?(Module)
                i.is_a?(input)
              elsif input.is_a?(Regexp)
                input.match?(i)
              elsif input.nil?
                i
              else
                i == input
              end
      result = false if check
      break unless result
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

  # map that accepts procs
  # Returns an array containing the result of the block provided
  # applied to each one of the elements of the array provided as argument.
  def my_map(input_proc = nil)
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
    result
  end

  # Combines the element in an array applying a binary operation
  # and returns the result in an accumulator variable ("memo")
  # When a block and a symbol is given, it prints an Error message.
  # Either a block or a symbol for a binary operation can be provided.
  # An initial value for memo can be provided.
  # If an initial value is not provided, memo takes the value of the first element in the array.
  def my_inject(memo = nil, sym = nil)
    raise LocalJumpError if memo.nil? && sym.nil? && !block_given?

    if is_a? Array
      if memo.is_a? Symbol
        sym = memo
        memo = nil
      end
      unless sym.nil?
        init_sym = memo.nil? ? self[0] : memo.public_send(sym, self[0])
      end
      if block_given?
        init_block = memo.nil? ? self[0] : yield(memo, self[0])
      end
      j = 1
      while j < length
        init_sym = init_sym.public_send(sym, self[j]) unless sym.nil?
        init_block = yield init_block, self[j] if block_given?
        j += 1
      end
      return init_sym unless sym.nil?
      return init_block if block_given?
    end
    if is_a? Range
      if memo.is_a? Symbol
        sym = memo
        memo = nil
      end
      unless sym.nil?
        init_sym = memo.nil? ? self.begin : memo.public_send(sym, self.begin)
      end
      if block_given?
        init_block = memo.nil? ? self.begin : yield(memo, self.begin)
      end
      j = Range.new(self.begin + 1, self.end)
      for i in j do
        init_sym = init_sym.public_send(sym, i) unless sym.nil?
        init_block = yield init_block, i if block_given?
      end
      return init_sym unless sym.nil?
      return init_block if block_given?
    end
  end
end

def multiply_els(array)
  array.my_inject(:*)
end

multiply_els([2, 4, 5])
# rubocop:enable Style/For
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Style/GuardClause
# rubocop:enable Metrics/AbcSize
