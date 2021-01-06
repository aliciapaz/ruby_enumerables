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

end

array = [1,1,3,4]

array.my_each_with_index { |num, index| puts "#{index}: #{num}"}
