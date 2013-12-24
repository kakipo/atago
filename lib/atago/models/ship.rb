module Atago
  module Model
    class Ship
      require 'csv'

      attr_reader :_id, :ship_id, :name, :nowhp, :maxhp, :karyoku, :raisou,
      :taiku, :soukou, :taisen, :kaihi, :sakuteki, :lucky, :cond

      # マッピング
      # TODO API-Model Mapper
      def initialize(hash)
        @_id        = hash["api_id"].to_i
        @ship_id    = hash["api_ship_id"].to_i
        @name       = Ship.find(@ship_id)
        @nowhp      = hash["api_nowhp"].to_i
        @maxhp      = hash["api_maxhp"].to_i
        @karyoku    = hash["api_karyoku"][0].to_i
        @raisou     = hash["api_raisou"][0].to_i
        @taiku      = hash["api_taiku"][0].to_i
        @soukou     = hash["api_soukou"][0].to_i
        @kaihi      = hash["api_kaihi"][0].to_i
        @sakuteki   = hash["api_sakuteki"][0].to_i
        @lucky      = hash["api_lucky"][0].to_i
        @cond       = hash["api_cond"].to_i
      end

      def self.find(ship_id)
        @master ||=
          CSV.table("data/ships.csv").reduce({}) do |hash, row|
            hash[row[:ship_id]] = row[:name]
            hash
          end
        @master[ship_id]
      end

    end
  end
end
