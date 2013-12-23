require "editwind"
class Handler
  def execute(edit_wind, cmd_wind, input_ch)
      cmd_wind.disp_ch(input_ch)
      # コマンド入力を処理
      case input_ch
      when 27 # ESC
      when ?i
        return EditHandler.new
      when ?j # カーソルを下へ
        edit_wind.cursor_down
      when ?k # カーソルを上へ
        edit_wind.cursor_up
      when 4 # C-d
        edit_wind.page_down
      when 21 # C-v
        edit_wind.page_up
      when 5 # C-e
        edit_wind.scroll_down
      when 25 # C-y
        edit_wind.scroll_up
      when ?q # プログラム終了
        raise "FEを終了しました"
      end
      return self
  end
end

class EditHandler
  def execute(edit_wind, cmd_wind, input_ch)
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