defmodule Stcl1.Storage.Question do
  use Memento.Table, attributes: [:chat_id, :question_type, :question, :status, :dt]

  # question_type: :big_who | :other
  # status: :wait | :done
end
