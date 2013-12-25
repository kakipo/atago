# coding: utf-8
# require "win_deckow"
module Atago

  class DeckHandler
    require 'haruna'
    require 'json'
    require "atago/models/deck"
    require "atago/models/ship"


    def initialize
      url = "http://125.6.189.215"
      # token = ""
      @client = Haruna::Client.new(token, url, proxy: "http://127.0.0.1:8888")
      @cache = {}
    end

    def ship3
      @cache[:ship3] ||= @client.call("api_get_member", "ship3", api_sort_order: 2, api_sort_key: 1)
      JSON.parse(@cache[:ship3].body.sub(/.*?{/, '{'))
    end

    def clear_cache(key=:all)
      if key == :all
        @cache = {}
      else
        @cache[key] = nil
      end
    end

    def redraw(win_deck, win_ship, win_cmd)
      deck_data = ship3["api_data"]["api_deck_data"].map{|hash| Atago::Model::Deck.new(hash) }
      ship_data = ship3["api_data"]["api_ship_data"].map{|hash| Atago::Model::Ship.new(hash) }
      win_deck.update(deck_data)
      win_ship.update(ship_data, win_deck.current_item)
      win_cmd.update(win_deck.current_item)
    end

    def reload(win_deck, win_ship, win_cmd)
      clear_cache(:ship3)
      redraw(win_deck, win_ship, win_cmd)
    end

    def execute(win_deck, win_ship, win_cmd, input_ch)
        win_cmd.disp_ch(input_ch)
        case input_ch
        when 10 # enter
          win_ship.highlight_on
          return ShipHandler.new
        when ?j # カーソルを下へ
          ship_data = ship3["api_data"]["api_ship_data"].map{|hash| Atago::Model::Ship.new(hash) }
          win_deck.cursor_down
          win_ship.update(ship_data, win_deck.current_item)
          win_cmd.update(win_deck.current_item)
          # win_ship.display(win_deck.current_item)
          # win_cmd.display(win_deck.current_item)
        when ?k # カーソルを上へ
          ship_data = ship3["api_data"]["api_ship_data"].map{|hash| Atago::Model::Ship.new(hash) }
          win_deck.cursor_up
          win_ship.update(ship_data, win_deck.current_item)
          win_cmd.update(win_deck.current_item)

          # win_ship.display(win_deck.current_item)
          # win_cmd.display(win_deck.current_item)
        # when 4 # C-d
        #   win_deck.page_down
        # when 21 # C-v
        #   win_deck.page_up
        # when 5 # C-e
        #   win_deck.scroll_down
        # when 25 # C-y
        #   win_deck.scroll_up
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
        when 27, ?q # ESC or q
          win_ship.highlight_off
          return DeckHandler.new
        else
          #nop
        end
        return self
    end
  end
end