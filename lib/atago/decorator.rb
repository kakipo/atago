require 'atago/util'
require 'csv'

module Atago
  # フォーマット用 CSV を元に
  # - 見出しを生成
  # - Model を整形された文字列に変更する
  #
  # フォーマット用 CSV の
  #    1 行目: モデルのキー
  #    2 行名: 見出し用文字列
  #    3 行目以降: サンプルデータ
  class Decorator

    def initialize(file_name)
      @table = CSV.table(file_name)

      # フォーマット用ハッシュ
      # 列毎の最大桁数をキー毎に保持する
      @max_length_hash = @table.headers.reduce({}) do |hash, col_key|
        hash[col_key] = @table[col_key].map{|val|
          Util.print_size(val.to_s) }.max
        hash
      end
    end

    def header_str
      header_row = @table[0]
      header_row.map{|item|
        col_key = item[0]
        val = item[1]
        len = @max_length_hash[col_key]
        Util.pad_to_print_size(val.to_s, len)
      }.join(" ")
    end

    def body_str(model)
      @table.headers.map {|key|
        len = @max_length_hash[key]
        Util.pad_to_print_size(model.send(key).to_s, len)
      }.join(" ")
    end

  end
end
