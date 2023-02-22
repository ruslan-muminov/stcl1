defmodule Stcl1.Storage.User do
  use Memento.Table, attributes: [:chat_id, :state, :dt]

  # state: :idle | :wait_who_big | :wait_for_answer | :finished
end
