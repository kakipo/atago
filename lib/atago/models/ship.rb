module Atago
  module Model
    require 'atago/util'
    class Ship
      require 'csv'
      @mlp = nil

      attr_reader :_id, :deck_name, :lv, :ship_id, :name, :nowhp, :maxhp, :karyoku, :raisou,
      :taiku, :soukou, :taisen, :kaihi, :sakuteki, :lucky, :cond

      # マッピング
      # TODO API-Model Mapper
      def initialize(hash)
        @_id        = hash["api_id"].to_i
        @deck_name  = "aaaa"
        @lv         = hash["api_lv"].to_i
        @ship_id    = hash["api_ship_id"].to_i
        @name       = Ship.name_of(@ship_id)
        @nowhp      = hash["api_nowhp"].to_i
        @maxhp      = hash["api_maxhp"].to_i
        @karyoku    = hash["api_karyoku"][0].to_i
        @raisou     = hash["api_raisou"][0].to_i
        @taiku      = hash["api_taiku"][0].to_i
        @soukou     = hash["api_soukou"][0].to_i
        @taisen     = hash["api_taisen"][0].to_i
        @kaihi      = hash["api_kaihi"][0].to_i
        @sakuteki   = hash["api_sakuteki"][0].to_i
        @lucky      = hash["api_lucky"][0].to_i
        @cond       = hash["api_cond"].to_i
      end

      def self.name_of(ship_id)
        @master ||=
          CSV.table("data/ships.csv").reduce({}) do |hash, row|
            hash[row[:ship_id]] = row[:name]
            hash
          end
        @master[ship_id]
      end

      def self.header_str
        header_row = CSV.table("data/dummy_ships.csv")[0]
        header_row.map{|item|
          col_key = item[0]
          val = item[1]
          len = Ship.max_length_hash("data/dummy_ships.csv")[col_key]
          Util.pad_to_print_size(val.to_s, len)
        }.join(" ")
      end

      # フォーマット出力用
      # 列毎の最大桁数をキャッシュし返す
      def self.max_length_hash(file_name)
        if @mlh.nil?
          dummy_table = CSV.table(file_name)
          @mlh = dummy_table.headers.reduce({}) do |hash, col_key|
            hash[col_key] = dummy_table[col_key].map{|val|
              Util.print_size(val.to_s) }.max
            hash
          end
        end
        @mlh
      end

      def to_s
        [:_id, :deck_name, :name, :lv, :maxhp, :karyoku, :raisou, :taiku, :soukou, :taisen, :kaihi, :sakuteki, :lucky, :cond].map {|key|
          len = Ship.max_length_hash("data/dummy_ships.csv")[key]
          Util.pad_to_print_size(self.send(key).to_s, len)
        }.join(" ")
      end

    end
  end
end
