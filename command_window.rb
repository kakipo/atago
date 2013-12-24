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
    begin_y = win_default.maxy - 2
    # win_default.setpos(begin_y, 0)
    # win_default.standout             # 以後の文字表示を反転色にする
    # win_default.addstr(" " * max_x)  # 画面横サイズ分の空白で帯を表現
    # win_default.standend             # 反転色解除
    # # 帯の真ん中にfile名を表示
    # win_default.setpos(begin_y, (max_x / 2) - (file_name.length / 2))
    # win_default.addstr(file_name)

    # 情報表示用のサブウィンドウを作成
    @window = win_default.subwin((max_y - begin_y), max_x, begin_y, 0)
    # @window.setpos(0, 0)
    # @window.attron(Curses::color_pair(3))
    # @window.addstr(" " * max_x)  # 画面横サイズ分の空白で帯を表現
    # @window.setpos(0, 0)
    # @window.addstr("[第二艦隊] [e]遠征  [h]補給  [r]リフレッシュ  [m]迎え入れ")
    # @window.attroff(Curses::A_COLOR)
    str_left = "[第二艦隊] [e]遠征  [h]補給  [r]リフレッシュ  [m]迎え入れ"
    str_right = "kakipo:35 燃: 1103, 弾: 7235, 鋼: 4913, ボ: 1852"
    pad = max_x - (Util.print_size(str_left) + Util.print_size(str_right))
    str = sprintf("%-#{pad}s%s", str_left, str_right)
    @window.setpos(0, 0)
    @window.attron(Curses::color_pair(3))
    @window.addstr(" " * max_x)  # 画面横サイズ分の空白で帯を表現
    @window.setpos(0, 0)
    @window.addstr(str)
    @window.attroff(Curses::A_COLOR)


    @window.setpos(1, 1)
    @window.addstr(">")
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