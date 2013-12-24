# require "win_deckow"
class DeckHandler
  def execute(win_deck, win_ship, win_cmd, input_ch)
      win_cmd.disp_ch(input_ch)
      case input_ch
      when 10 # enter
        win_ship.highlight_on
        return ShipHandler.new
      when ?j # カーソルを下へ
        win_deck.cursor_down
      when ?k # カーソルを上へ
        win_deck.cursor_up
      when 4 # C-d
        win_deck.page_down
      when 21 # C-v
        win_deck.page_up
      when 5 # C-e
        win_deck.scroll_down
      when 25 # C-y
        win_deck.scroll_up
      when ?q # プログラム終了
        raise "FEを終了しました"
      end
      return self
  end
end

class ShipHandler
  def execute(win_deck, win_ship, win_cmd, input_ch)
      win_cmd.disp_ch(input_ch)
      case input_ch
      when ?j # カーソルを下へ
        win_ship.cursor_down
      when ?k # カーソルを上へ
        win_ship.cursor_up
      when 4 # C-d
        win_ship.page_down
      when 21 # C-v
        win_ship.page_up
      when 5 # C-e
        win_ship.scroll_down
      when 25 # C-y
        win_ship.scroll_up
      when 27 # ESC
      when ?q
        win_ship.highlight_off
        return DeckHandler.new
      else
        #nop
      end
      return self
  end
end