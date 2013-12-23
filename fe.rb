# coding: utf-8
$:.unshift File.dirname(__FILE__)
require "curses"
require "deck_window"
require "command_window"
require "ship_window"
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
win_default = Curses.stdscr
# 編集エリアウィンドウを作成
win_deck = DeckWindow.new(win_default)
# 情報表示エリアウィンドウを作成
win_cmd = CommandWindow.new(win_default, file_name)
# [追加]イベント処理クラスを生成
handler = Handler.new

# ファイルをオープンし内容を編集エリアに表示する
win_deck.display(file_name)

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
    ch = win_deck.getch #１文字入力。
    # イベント処理クラスで処理分岐を行う
    handler = handler.execute(win_deck, win_cmd, ch)
  end
end
#コンソール画面を終了
Curses.close_screen