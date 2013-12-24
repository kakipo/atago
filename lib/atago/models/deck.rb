module Atago
  module Model
    class Deck

      attr_reader :_id, :name, :missions, :ships

      # マッピング
      # TODO API-Model Mapper
      def initialize(hash)
        @_id        = hash["api_id"].to_i
        @name       = hash["api_name"]
        # @missions   = hash["api_mission"].map{}
        @ships      = hash["api_ship"]
      end

    end
  end
end
