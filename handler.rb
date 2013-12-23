# require "win_deckow"
class Handler
  def execute(win_deck, win_cmd, input_ch)
      win_cmd.disp_ch(input_ch)
      # コマンド入力を処理
      case input_ch
      when 27 # ESC
      when ?i
        return EditHandler.new
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

class EditHandler
  def execute(win_deck, win_cmd, input_ch)
      # 文字入力を処理
      case input_ch
      when 27 # ESC
        return Handler.new
      else
        #nop
      end
      return self
  end
end