defmodule Stcl1.Message.Handler do
  alias Stcl1.Message.Q
  alias Stcl1.Message.Sender
  alias Stcl1.Settings
  alias Stcl1.Storage
  alias Stcl1.Storage.Interfaces.Users
  alias Stcl1.UpdatesOperator

  use Q

  @operator_chat_id Settings.operator_chat_id()

  def handle_message(%{chat_id: @operator_chat_id}, text) do
    # TODO: create UpdatesOperator.handle_message/1
    UpdatesOperator.handle_message(text)
  end

  def handle_message(%{state: "banned"}, _text) do
    :dopizdelsya
  end

  def handle_message(user, "/start") do
    Sender.send_text_with_menu(user, :first)
  end

  def handle_message(user, @q_back) do
    Sender.send_menu(user)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_address) do
    Sender.send_text_with_menu(user, :q_address)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_shows_list) do
    Sender.send_text_with_menu(user, :q_shows_list)
    Users.update_state(user, "idle")
  end

  ###################################################################
  # Покупка и возврат билетов
  #
  def handle_message(user, @q_tickets) do
    Sender.send_tickets_menu(user)
    Users.update_state(user, "tickets")
  end

  def handle_message(%{state: "tickets"} = user, @q_buy_ticket_on_event) do
    Sender.send_text_with_menu(user, :q_buy_ticket_on_event)
    Users.update_state(user, "idle")
  end

  def handle_message(%{state: "tickets"} = user, @q_unrecieved_ticket) do
    Sender.send_text_with_menu(user, :q_unrecieved_ticket)
    Users.update_state(user, "idle")
  end

  def handle_message(%{state: "tickets"} = user, @q_return_ticket) do
    Sender.send_text_with_menu(user, :q_return_ticket)
    Users.update_state(user, "idle")
  end
  #
  ###################################################################

  ###################################################################
  # Анкета: на какое шоу пойти
  #
  def handle_message(user, @q_show_advice) do
    variants = [[@q_show_advice_standup], [@q_show_advice_experiment],
                [@q_show_advice_panel], [@q_show_new_jokes], [@q_back]]
    Sender.send_variants(user, variants, :q_show_advice1)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_advice_standup) do
    Sender.send_album(user, :group1)
    variants = [[@q_show_advice_something_else], [@q_back]]
    Sender.send_variants(user, variants, :q_show_advice_standup)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_advice_experiment) do
    Sender.send_album(user, :group2)
    variants = [[@q_show_advice_something_else], [@q_back]]
    Sender.send_variants(user, variants, :q_show_advice_experiment)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_advice_panel) do
    Sender.send_album(user, :group3)
    variants = [[@q_show_advice_something_else], [@q_back]]
    Sender.send_variants(user, variants, :q_show_advice_panel)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_new_jokes) do
    Sender.send_album(user, :group6)
    variants = [[@q_show_advice_something_else], [@q_back]]
    Sender.send_variants(user, variants, :q_show_new_jokes)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_advice_something_else) do
    variants = [[@q_show_advice_yes], [@q_show_advice_no], [@q_back]]
    Sender.send_variants(user, variants, :q_show_advice2)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_advice_yes) do
    Sender.send_album(user, :group4)
    variants = [[@q_back]]
    Sender.send_variants(user, variants, :q_show_advice_yes)
    Users.update_state(user, "advice")
  end

  def handle_message(%{state: "advice"} = user, @q_show_advice_no) do
    Sender.send_album(user, :group5)
    variants = [[@q_back]]
    Sender.send_variants(user, variants, :q_show_advice_no)
    Users.update_state(user, "advice")
  end
  #
  ###################################################################

  def handle_message(user, @q_show_date) do
    Sender.send_album(user, :group7)
    Sender.send_text_with_menu(user, :q_show_date)
    Users.update_state(user, "idle")
  end

  ###################################################################
  # Составы
  #
  def handle_message(user, @q_lineup) do
    variants = [[@q_lineup_big], [@q_lineup_tough], [@q_lineup_women]]
    Sender.send_variants(user, variants, :q_lineup)
    Users.update_state(user, "lineup")
  end

  def handle_message(%{state: "lineup"} = user, @q_lineup_big) do
    message = Storage.read_lineup_text(:big)
    Sender.send_text_with_menu(user, message)
    Users.update_state(user, "idle")
  end

  def handle_message(%{state: "lineup"} = user, @q_lineup_tough) do
    message = Storage.read_lineup_text(:tough)
    Sender.send_text_with_menu(user, message)
    Users.update_state(user, "idle")
  end

  def handle_message(%{state: "lineup"} = user, @q_lineup_women) do
    message = Storage.read_lineup_text(:women)
    Sender.send_text_with_menu(user, message)
    Users.update_state(user, "idle")
  end
  #
  ###################################################################

  def handle_message(user, @q_show_duration) do
    Sender.send_text_with_menu(user, :q_show_duration)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_order_food_drink) do
    Sender.send_text_with_menu(user, :q_order_food_drink)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_show_passport) do
    Sender.send_text_with_menu(user, :q_show_passport)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_child_with_batya) do
    Sender.send_text_with_menu(user, :q_child_with_batya)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_parking) do
    Sender.send_text_with_menu(user, :q_parking)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_loyalty_card) do
    Sender.send_text_with_menu(user, :q_loyalty_card)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_our_soc_networks) do
    Sender.send_text_with_menu(user, :q_our_soc_networks)
    Users.update_state(user, "idle")
  end

  def handle_message(user, @q_gift_cert) do
    Sender.send_album(user, :group8)
    Sender.send_text_with_menu(user, :q_gift_cert)
    Users.update_state(user, "idle")
  end

  def handle_message(user, text) do
    bot_token = Settings.bot_token()
    result = UpdatesOperator.send_to_operator_from_user(bot_token, user.chat_id, text)
    Sender.send_text_with_menu(user, result)
  end
end
