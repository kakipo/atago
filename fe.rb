# coding: utf-8
$:.unshift File.dirname(__FILE__)
require "curses"
require "editwind"
require "commandwind"
# [追加]
require "handler"

#/Users/kakipo/.rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/forwardable.rb:103: warning: already initialized constant Forwardable::FORWARDABLE_VERSION
#/Users/kakipo/.rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/Forwardable.rb:103: warning: previous definition of FORWARDABLE_VERSION was here



#ファイル名をコマンドライン引数として受け取る
if ARGV.size != 1
  #コマンドライン引数がない場合
  printf("usage: fe file_name\n");
  exit
else
  file_name = ARGV[0]
end
#コンソール画面を初期化し初期設定を行う
Curses.init_screen
Curses.cbreak
Curses.noecho
# デフォルトウィンドウを取得
defo_wind = Curses.stdscr
# 編集エリアウィンドウを作成
edit_wind = EditWind.new(defo_wind)
# 情報表示エリアウィンドウを作成
cmd_wind = CommandWind.new(defo_wind, file_name)
# [追加]イベント処理クラスを生成
handler = Handler.new

# ファイルをオープンし内容を編集エリアに表示する
edit_wind.display(file_name)

# C-c をトラップ
Signal.trap(:INT){
  puts "...GOOD BYE..."
  exit(0)
}
# C-y
# Signal.trap(:SIGTSTP){
#   puts "+"  * 2000
# }

# [追加]イベントループ
begin
  while true
    ch = edit_wind.getch #１文字入力。
    # イベント処理クラスで処理分岐を行う
    handler = handler.execute(edit_wind, cmd_wind, ch)
  end
end
#コンソール画面を終了
Curses.close_screen