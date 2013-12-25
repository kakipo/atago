require 'Forwardable'

module Atago
  class Text
    extend Forwardable
    def initialize
      # 委譲するArrayインスタンスを生成
      @lines = Array.new
    end
    # Arrayのインスタンス@linesへ委譲するメソッド
    def_delegators :@lines, :[], :length, :push


    def insert_char(pos_y,pos_x,input_ch)
      # データの範囲内かをチェック
      return unless((pos_y < @lines.size) and (pos_x < (@lines[pos_y].length+1)))
      # 文字列の指定した場所に一文字挿入
      @lines[pos_y].insert(pos_x,input_ch.chr)
    end


    def delete_char(pos_y,pos_x)
      # データの範囲内かをチェック
      return unless((pos_y < @lines.size) and (pos_x < @lines[pos_y].length))
      # 文字列の指定した場所を一文字削除するために
      # 一旦、文字列を1バイトずつ配列に分解
      arr = @lines[pos_y].split(//)
      # 該当箇所の要素を削除（つまり1バイト削除）
      arr.delete_at(pos_x)
      # 配列を再度文字列に変換
      @lines[pos_y] = arr.to_s
    end


    def save(file_name)
      # ファイルをWriteモードでオープン
      f = File.open(file_name,"w")
      # 改行を付加してデータを順にファイルに書き込み
      @lines.each {|str| f << str + "\n"}
      f.close
    end

  end
end