defmodule Stcl1.Storage.UserExt do
  use Memento.Table, attributes: [:chat_id, :state, :dt, :dt_reg]

  # state: :idle | :tickets | :advice | :lineup | :wait_who_big | :wait_for_answer | :finished | :banned
end
