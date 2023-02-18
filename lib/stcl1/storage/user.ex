defmodule Stcl1.Storage.User do
  use Memento.Table, attributes: [:chat_id, :state]

  # state: :idle | :wait_who_big | :wait_for_answer (maybe)
end
