defmodule Stcl1.Menu do
  alias Stcl1.Message.Q

  use Q

  def main_keyboard do
    [[@q_lineup], [@q_shows_list], [@q_show_advice], [@q_show_date], [@q_tickets],
     [@q_loyalty_card], [@q_gift_cert], [@q_our_soc_networks], [@q_show_duration],
     [@q_order_food_drink], [@q_show_passport], [@q_child_with_batya], [@q_address], [@q_parking]]
  end

  def tickets_keyboard do
    [[@q_buy_ticket_on_event], [@q_unrecieved_ticket], [@q_return_ticket], [@q_back]]
  end
end
