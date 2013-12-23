require "curses"

class CommandWind
  def initialize(wind,file_name="")
    max_y   = wind.maxy
    max_x   = wind.maxx
    begin_y = wind.maxy - 2
    wind.setpos(begin_y, 0)
    wind.standout             # 以後の文字表示を反転色にする
    wind.addstr(" " * max_x)  # 画面横サイズ分の空白で帯を表現
    wind.standend             # 反転色解除
    # 帯の真ん中にfile名を表示
    wind.setpos(begin_y, (max_x / 2) - (file_name.length / 2))
    wind.addstr(file_name)
    # 情報表示用のサブウィンドウを作成
    @window = wind.subwin((max_y - begin_y), max_x,begin_y, 0)


    @window.attron(Curses.color_pair(3))
    @window.attron(Curses::A_BLINK)
    # @window.attrset(Curses::A_BLINK)
    # @window.box(?|,?-,?*)
    @window.setpos(1, 10)
    @window.addstr("hogehoge")
    # Curses.attroff(Curses::A_COLOR)

    @window.refresh
  end

  def disp_ch(input_ch)
    max_x = @window.maxx
    @window.setpos(1, 0)
    @window.addstr(" " * max_x) # 一旦クリア
    @window.setpos(1, 10)
    @window.addstr(input_ch.to_s)
    @window.refresh
  end

end