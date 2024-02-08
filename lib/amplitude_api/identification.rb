# frozen_string_literal: true

class AmplitudeAPI
  # AmplitudeAPI::Identification
  class Identification
    # @!attribute [ rw ] user_id
    #   @return [ String ] the user_id to be sent to Amplitude
    attr_reader :user_id
    # @!attribute [ rw ] device_id
    #   @return [ String ] the device_id to be sent to Amplitude
    attr_accessor :device_id
    # @!attribute [ rw ] user_properties
    #   @return [ String ] the user_properties to be attached to the Amplitude Identify
    attr_accessor :user_properties
    # @!attribute [ rw ] country
    #   @return [ String ] the country to be sent to the Amplitude Identify
    attr_accessor :country
    # @!attribute [ rw ] region
    #   @return [ String ] the region to be sent to the Amplitude Identify
    attr_accessor :region
    # @!attribute [ rw ] city
    #   @return [ String ] the city to be sent to the Amplitude Identify
    attr_accessor :city
    # @!attribute [ rw ] dma
    #   @return [ String ] the dma to be sent to the Amplitude Identify
    attr_writer :dma

    # Create a new Identification
    #
    # @param [ String ] user_id a user_id to associate with the identification
    # @param [ String ] device_id a device_id to associate with the identification
    # @param [ Hash ] user_properties various properties to attach to the user identification
    def initialize(user_id: "", device_id: nil, user_properties: {}, country: nil, region: nil, city: nil, dma: nil)
      self.user_id = user_id
      self.device_id = device_id if device_id
      self.user_properties = user_properties
      self.country = country
      self.region = region
      self.city = city
      self.dma = dma
    end

    def user_id=(value)
      @user_id =
        if value.respond_to?(:id)
          value.id
        else
          value || AmplitudeAPI::USER_WITH_NO_ACCOUNT
        end
    end

    # @return [ Hash ] A serialized Event
    #
    # Used for serialization and comparison
    def to_hash
      {
        user_id: user_id,
        user_properties: user_properties,
        country: country,
        region: region,
        city: city,
        dma: dma
      }.tap { |hsh| hsh[:device_id] = device_id if device_id }
    end

    # @return [ true, false ]
    #
    # Compares +to_hash+ for equality
    def ==(other)
      if other.respond_to?(:to_hash)
        to_hash == other.to_hash
      else
        false
      end
    end

    private

    # I don't really know what DMA is, but I don't think we need it. However if we don't send a value, it resets the others. So if we have country, region and city but no DMA let's send them an empty string
    def dma
      if @dma == nil && country && region && city
        ''
      else
        @dma
      end
    end

  end
end
