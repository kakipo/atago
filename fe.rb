# coding: utf-8
$:.unshift File.dirname(__FILE__)
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "curses"
require "lib/atago/views/command_window"
require "lib/atago/views/deck_window"
require "lib/atago/views/ship_window"
require "lib/atago/handlers"

#/Users/kakipo/.rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/forwardable.rb:103: warning: already initialized constant Forwardable::FORWARDABLE_VERSION
#/Users/kakipo/.rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/Forwardable.rb:103: warning: previous definition of FORWARDABLE_VERSION was here

#コンソール画面を初期化し初期設定を行う
Curses.init_screen
Curses.cbreak
Curses.noecho
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
Curses.init_pair(3, -1, Curses::COLOR_BLUE)

# デフォルトウィンドウを取得
win_default = Curses.stdscr
win_deck = Atago::View::DeckWindow.new(win_default)
win_ship = Atago::View::ShipWindow.new(win_default)
win_cmd = Atago::View::CommandWindow.new(win_default)
handler = Atago::DeckHandler.new

# ファイルをオープンし内容を編集エリアに表示する
handler.redraw(win_deck, win_ship, win_cmd)
# win_deck.display
# win_ship.display(win_deck.current_item)
# win_cmd.display(win_deck.current_item)

# C-c をトラップ
Signal.trap(:INT){
  puts "...GOOD BYE..."
  exit(0)
}

begin
  while true
    ch = win_default.getch
    handler = handler.execute(win_deck, win_ship, win_cmd, ch)
  end
end

Curses.close_screen