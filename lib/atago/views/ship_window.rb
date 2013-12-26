# coding: utf-8
require "atago/decorator"
require "atago/models/deck"
require "atago/models/ship"

module Atago
  module View
    class ShipWindow < BaseWindow

      # 艦船用のサブウィンドウを作成
      def initialize(win_default)
        max_y   = win_default.maxy
        max_x   = win_default.maxx
        window_top = 10

        @decorator = Decorator.new("data/formatter_ships.csv")

        # ヘッダの作成
        header_height = 1
        setup_header(win_default, window_top, @decorator.header_str)

        # 本体の作成
        command_height = 2
        body_height = max_y - (window_top + header_height + command_height)
        body_top = window_top + header_height
        @window = win_default.subwin(body_height, max_x, body_top,  0)
        @window.scrollok(true)
        @window.refresh
      end

      def update(data, current_deck)
        clear
        @data = data.select{|ship| current_deck.ships.include?(ship._id)}

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
    end
  end
end