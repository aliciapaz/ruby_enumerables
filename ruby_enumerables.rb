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

end

array = [1,1,3,4]

array.my_select { |num| num > 1 }
