# coding: utf-8
require "atago/decorator"
require "atago/views/base_window"

module Atago
  module View
    class DeckWindow < BaseWindow

      def initialize(win_default)
        max_y   = win_default.maxy
        max_x   = win_default.maxx
        window_height = 10
        window_top = 0

        @decorator = Decorator.new("data/formatter_decks.csv")

        # ヘッダの作成
        header_height = 1
        setup_header(win_default, window_top, @decorator.header_str)

        # 本体の作成
        body_top = window_top + header_height
        @window = win_default.subwin(window_height, max_x, body_top, 0)
        @window.scrollok(true)
        @window.refresh
        # @decorator = Decorator.new("data/")
      end

      def update(data)
        @data = data

        # 初期表示として0行目からウィンドウの最大行数まで一行ずつ表示する
        @data[0..(@window.maxy - 1)].each_with_index do |item, idx|
           @window.setpos(idx, 0)
           str = @decorator.body_str(item)
           @window.addstr(str)
        end

        @cursor_y = 0
        # インスタンス変数の@top_statementとは、現在表示されている一番上のデータが、実際のデータ（@data）では何行目かを表現しています。下へスクロールすると、この値は増えていき、上へスクロールすると減っていきます。ただし当然ですが実際のデータ数以上には増えませんし、0未満にもなりません。
        @top_statement = 0
        @window.setpos(@cursor_y, 0)

        highlight_on

        @window.refresh
      end


      def display
        @data = Text.new
        table = CSV.table("decks.csv")
        # フォーマット用に各列毎の最大桁数を保持しておく
        max_length_hash = table.headers.reduce({}) do |hash, header|
          hash[header] = table[header].map{|cell| Util.print_size(cell.to_s) }.max
          hash
        end

        table.each do |row|
          str_arr = row.map{|item|
            len = max_length_hash("decks.csv")[item[0]]
            Util.pad_to_print_size(item[1].to_s, len)
          }
          @data.push(str_arr.join(" "))
        end

        # 初期表示として0行目からウィンドウの最大行数まで一行ずつ表示する
        @data[0..(@window.maxy - 1)].each_with_index do |line, idx|
           @window.setpos(idx, 0)
           @window.addstr(line)
        end

        @cursor_y = 0
        # インスタンス変数の@top_statementとは、現在表示されている一番上のデータが、実際のデータ（@data）では何行目かを表現しています。下へスクロールすると、この値は増えていき、上へスクロールすると減っていきます。ただし当然ですが実際のデータ数以上には増えませんし、0未満にもなりません。
        @top_statement = 0
        @window.setpos(@cursor_y, 0)

        highlight_on

        @window.refresh
      end
    end
  end
end