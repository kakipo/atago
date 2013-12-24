# coding: utf-8
require "curses"

class ShipWindow < BaseWindow

  # 艦船用のサブウィンドウを作成
  def initialize(win_default)
    max_y   = win_default.maxy
    max_x   = win_default.maxx
    window_top = 10

    # ヘッダの作成
    header_height = 1
    setup_header(win_default, window_top, "ships.csv")

    # 本体の作成
    command_height = 2
    body_height = max_y - (window_top + header_height + command_height)
    body_top = window_top + header_height
    @window = win_default.subwin(body_height, max_x, body_top,  0)
    @window.scrollok(true)
    @window.refresh
  end

  def display(deck_id)
    clear

    deck_id = deck_id.split(/\s+/)[1]

    @data = Text.new
    table = CSV.table("ships.csv")

    table.each do |row|
      next unless row[:group] == deck_id
      str_arr = row.map{|item|
        len = max_length_hash("ships.csv")[item[0]]
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

    @window.refresh
  end



end