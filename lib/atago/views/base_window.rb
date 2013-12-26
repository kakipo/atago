# coding: utf-8
module Atago
  module View
    class BaseWindow

      def clear
        (0..(@window.maxy - 1)).each do |idx|
           @window.setpos(idx, 0)
           @window.addstr(" " * @window.maxx)
        end
      end

      def data_to_str(item)
        @decorator.body_str(item)
      end

      def highlight_on
        str = data_to_str(@data[@cursor_y + @top_statement])
        @window.setpos(@cursor_y, 0)
        @window.attron(Curses.color_pair(2))
        @window.addstr(" " * @window.maxx)
        @window.setpos(@cursor_y, 0)
        @window.addstr(str)
        @window.attroff(Curses::A_COLOR)
        @window.refresh
      end

      def highlight_off
        str = data_to_str(@data[@cursor_y + @top_statement])
        @window.setpos(@cursor_y, 0)
        @window.addstr(" " * @window.maxx)
        @window.setpos(@cursor_y, 0)
        @window.addstr(str)
        @window.refresh
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

        @window.refresh
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

        @window.refresh
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

      def current_item
        @data[@cursor_y + @top_statement]
      end

      def setup_header(win_default, win_top, header_str)
        max_x   = win_default.maxx
        header_height = 1
        # ヘッダ行の作成
        win_header = win_default.subwin(header_height, max_x, win_top, 0)
        win_header.setpos(0, 0)

        # highlight legend
        win_header.setpos(0, 0)
        win_header.attron(Curses::A_UNDERLINE)
        win_header.addstr(" " * win_header.maxx)
        win_header.setpos(0, 0)
        win_header.addstr(header_str)
        win_header.attroff(Curses::A_UNDERLINE)
        win_header.refresh
      end

    end
  end
end