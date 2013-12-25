module Atago
  class Util
    # 文字列の表示幅を求める
    def self.print_size(string)
      string.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
    end

    # 指定された表示幅に合うようにパディングする
    def self.pad_to_print_size(string, size)
      # パディングサイズを求める
      padding_size = size - print_size(string)
      # string の表示幅が size より大きい場合はパディングサイズは 0 とする.
      padding_size = 0 if padding_size < 0
      # パディングする.
       string + (' ' * padding_size)
    end
  end
end