module Reserve

  module InstanceMethods

    def ratio
      if reservations.size > 0 
        reservations.size / listings.size 
      end 
    end

  end

  module ClassMethods

    # def highest_ratio_res_to_listings
    #   self.all.max do |a, b| 
    #     a.ratio <=> b.ratio
    #   end
    # end
    def highest_ratio_res_to_listings
      temp = 0
      result = []
        self.all.select do |n| 
          if n.ratio != nil && n.ratio > temp 
            result = n
            temp = n.ratio
          end
        end
      result
    end
    def most_res
      self.all.max {|a,b| a.reservations.size <=> b.reservations.size}
    end
  end

end