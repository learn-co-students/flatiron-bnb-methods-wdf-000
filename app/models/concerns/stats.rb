module Stats
  def highest_ratio_res_to_listings
    self.all[
      self.all.map do |self_obj|
        num_reservations = self_obj.listings.map{ |listings| listings.reservations.length }.inject(0){|sum,i| sum + i}
        if self_obj.listings.length == 0 then 0 else num_reservations / self_obj.listings.length end
      end.each_with_index.max[1]
    ]
  end

  def most_res
    self.all[
      self.all.map do |self_obj| 
        self_obj.listings.map do |listings| 
          listings.reservations.length
        end.inject(0){|sum,i| sum + i}
      end.each_with_index.max[1]
    ]
  end
end
