defmodule Stcl1.Storage.QuestionLog do
  use Memento.Table,
    attributes: [:id, :question, :answer, :chat_id, :dt, :dt_diff],
    type: :ordered_set,
    autoincrement: true
end
