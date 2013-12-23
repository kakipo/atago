# coding: utf-8
require "curses"
require "text"
require "csv"
require "pry"

class EditWind

  def initialize(wind)
    # デフォルトウィンドウの高さを少し小さくしたサブウィンドウを作成
    @window = wind.subwin(wind.maxy - 2, wind.maxx, 0, 0)
    # スクロール機能をONにする
    @window.scrollok(true)
    # カーソルを隠す
    Curses.curs_set(0)
    # COLOR_WHITE が薄いのでデフォルトの設定を使う
    Curses.use_default_colors
    # 色を有効にする
    Curses.start_color
    # http://dev.yorhel.nl/dump/nccolour
    # default       -1
    # COLOR_BLACK   0
    # COLOR_RED     1
    # COLOR_GREEN   2
    # COLOR_YELLOW  3
    # COLOR_BLUE    4
    # COLOR_MAGENTA 5
    # COLOR_CYAN    6
    # COLOR_WHITE   7
    Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(2, -1, Curses::COLOR_GREEN) # default color & green
    Curses.init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
  end

  def display(file_name)
    begin
      # ファイルをオープンし、全内容を配列に読み込んでおく
      @data = Text.new # "@data=[]"を修正

      table = CSV.table(file_name)

      # フォーマット用に各列毎の最大桁数を保持しておく
      max_length_hash = table.headers.reduce({}) do |hash, header|
        hash[header] = table[header].map{|cell| print_size(cell.to_s) }.max
        hash
      end

      table.each do |row|
        str_arr = row.map{|item|
          len = max_length_hash[item[0]]
          pad_to_print_size(item[1].to_s, len)
        }
        @data.push(str_arr.join(" "))
      end

      # 初期表示として0行目からウィンドウの最大行数まで一行ずつ表示する
      @data[0..(@window.maxy-1)].each_with_index do |line, idx|
         @window.setpos(idx, 0)
         @window.addstr(line)
      end
    rescue
      # ファイルをオープンできない等、なにか例外が起きた場合
      raise IOError,"FILE OPEN ERROR: #{file_name}"
    end
    # [追加]
    @cursor_y = 0
    @cursor_x = 0
    # インスタンス変数の@top_statementとは、現在表示されている一番上のデータが、実際のデータ（@data）では何行目かを表現しています。下へスクロールすると、この値は増えていき、上へスクロールすると減っていきます。ただし当然ですが実際のデータ数以上には増えませんし、0未満にもなりません。
    @top_statement = 0
    @window.setpos(@cursor_y,@cursor_x)

    highlight_on

    @window.refresh
  end

  def getch
    return @window.getch
  end

  def highlight_on
    str = @data[@cursor_y + @top_statement]
    @window.setpos(@cursor_y, 0)
    # @window.attron(Curses::A_REVERSE)
    @window.attron(Curses.color_pair(2))
    @window.addstr(" " * @window.maxx)
    @window.setpos(@cursor_y, 0)
    @window.addstr(str)
    # @window.attroff(Curses::A_REVERSE)
    @window.attroff(Curses::A_COLOR)
  end

  def highlight_off
    str = @data[@cursor_y + @top_statement]
    @window.setpos(@cursor_y, 0)
    @window.addstr(" " * @window.maxx)
    @window.setpos(@cursor_y, 0)
    @window.addstr(str)
  end

  # カーソルを下へ移動。
  # ウィンドウの下端より下へカーソルが移動
  # しようとした場合はスクロール
  def cursor_down
    # 動く前に現在の行のハイライトをオフ
    highlight_off

    if @cursor_y >= (@window.maxy - 1) # ウィンドウの最下部にカーソルがある場合
      scroll_down
    elsif @cursor_y >= (@data.length - 1) # データの最下部にカーソルがある場合
      # nop
    else
      @cursor_y += 1
    end
    @window.setpos(@cursor_y, 0)

    # 動いた後に現在の行のハイライトをオン
    highlight_on

    @window.refresh
  end

  # カーソルを上へ移動。
  # ウィンドウの上端より上へカーソルが移動
  # しようとした場合はスクロール
  def cursor_up
    # 動く前に現在の行のハイライトをオフ
    highlight_off

    if @cursor_y <= 0
      scroll_up
    else
      @cursor_y -= 1
    end
    @window.setpos(@cursor_y, 0)

    # 動いた後に現在の行のハイライトをオン
    highlight_on

    @window.refresh
  end


  # 1行上へスクロール
  def scroll_up
    highlight_off
    if( @top_statement > 0 )
      # すでにスクロールされている場合のみ上へスクロール
      #（表示されている文字は下へずれる）
      @window.scrl(-1)
      @top_statement -= 1
      # 下へずれた分、空いた場所にデータを一行表示
      str = @data[@top_statement]
      if( str )
        @window.setpos(0, 0)
        @window.addstr(str)
      end
    end
    highlight_on
  end


  # 1行下へスクロール
  def scroll_down
    highlight_off
    if( @top_statement + @window.maxy < @data.length )
      # 表示されているデータの最下行が全データの最大行より
      # 小さい場合は下へスクロール
      #（表示されている文字は上へずれる）
      @window.scrl(1)
      # 上へずれた分、空いた場所にデータを一行表示
      str = @data[@top_statement + @window.maxy]
      if( str )
        @window.setpos(@window.maxy - 1, 0)
        @window.addstr(str)
      end
      @top_statement += 1
    end
    highlight_on
  end

  # 1ページ上へスクロール
  def page_up
    @window.maxy.times do
      scroll_up
    end
  end

  # 1ページ下へスクロール
  def page_down
    @window.maxy.times do
      scroll_down
    end
  end


  # 文字列の表示幅を求める
  def print_size(string)
    string.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
  end

  # 指定された表示幅に合うようにパディングする
  def pad_to_print_size(string, size)
    # パディングサイズを求める
    padding_size = size - print_size(string)

    # string の表示幅が size より大きい場合はパディングサイズは 0 とする.
    padding_size = 0 if padding_size < 0

    # パディングする.
     string + (' ' * padding_size)
  end


end