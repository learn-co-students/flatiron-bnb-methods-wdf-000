module CustomValidations 
  
  ###### LISTING VALIDATIONS #####

  class ListingDateValidator < ActiveModel::Validator
    def validate(record)
      unless Listing.find(record.listing_id).nil? || (!Listing.find(record.listing_id).neighborhood.city.nil? && !Listing.find(record.listing_id).neighborhood.city.city_openings(record.checkin, record.checkout).empty?)
        record.errors[:checkin] << "There appear to be no listings available in that city for those dates."
        record.errors[:checkout] << "There appear to be no listings available in that city for those dates."
      end
    end
  end
end
