module Enumerable

    # Iterates through the object, identical to #each
    def my_each
        for i in self
            yield i
        end
    end

    #Iterates through the object, returning value and index. Identical to #each_with_index
    def my_each_with_index
      i = 0
        while i < self.length
            yield self[i], i
            i += 1
        end
    end

    # Creates a new array containing the elements of self that match the provided test.

    def my_select
        result = []
        for i in self
            result.push(i) if yield i
        end
        p result
    end

    # Returns true if every value passes a test (defined as a block) or if, no block is given returns true if all values are truthy.
    def my_all?
      result = true
      unless block_given?
        for i in self
          result = false unless i
          break unless i
        end
        return result
      end
      for i in self
        result = false unless yield i
        break unless yield i
      end
      return result
    end

    # Returns true if any value passes a test defined as a block. If no block is given, it returns true if any value is truthy.
    def my_any?
        result = false
        unless block_given?
          for i in self
            result = true if i
            break if i
          end
          return result
        end
        for i in self
          result = true if yield i
          break if yield i
        end
        return result
      end

      # Returns true if none of the values passes a test (defined as a block) or if, no block is given returns true if none of the values are truthy.
      def my_none?
        result = true
        unless block_given?
          for i in self
            result = false if i
            break if i
          end
          return result
        end
        for i in self
          result = false if yield i
          break if yield i
        end
        return result
      end

end

array = [1,1,1,1]

array.my_none? { |num| num > 1 }
