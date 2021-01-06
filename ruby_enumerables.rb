module Enumerable

    # Iterates through the object, identical to #each 
    def my_each
        for i in self
            yield i
        end
    end

end

array = [1,2,3,4]

array.my_each { |num| puts "hello + #{num}"}