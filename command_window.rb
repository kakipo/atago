# coding: utf-8
# require "curses"

# CommandWindow は
#   - メニューバー
#   - プロンプトバー
# の 2 行からなる
class CommandWindow

  def initialize(win_default)

    # メニューバーの作成
    max_y   = win_default.maxy
    max_x   = win_default.maxx
    height  = 2
    top     = win_default.maxy - height

    # 情報表示用のサブウィンドウを作成
    @window = win_default.subwin(height, max_x, top, 0)
    # メニューバー
    # refresh_menu_bar("---")

    # プロンプトバー
    @window.setpos(1, 1)
    @window.addstr(">")

    @window.refresh
  end

  def display(deck_id)
    # setup menu string
    deck_name = deck_id.split(/\s+/)[1]
    str_left = "[#{deck_name}] [e]遠征  [h]補給  [r]リフレッシュ  [m]迎え入れ"
    str_right = "kakipo:35 燃: 1103, 弾: 7235, 鋼: 4913, ボ: 1852"
    pad = @window.maxx - (Util.print_size(str_left) + Util.print_size(str_right))
    str = sprintf("%-#{pad}s%s", str_left, str_right)

    # show menu
    @window.setpos(0, 0)
    @window.attron(Curses::color_pair(3))
    @window.addstr(" " * @window.maxx)  # 画面横サイズ分の空白で帯を表現
    @window.setpos(0, 0)
    @window.addstr(str)
    @window.attroff(Curses::A_COLOR)
    @window.refresh
  end


  def disp_ch(input_ch)
    max_x = @window.maxx
    @window.setpos(1, 0)
    @window.addstr(" " * max_x) # 一旦クリア
    @window.setpos(1, 0)
    @window.addstr("> #{input_ch.to_s}")
    @window.refresh
  end

end