defmodule Stcl1.Storage.QuestionLog do
  use Memento.Table,
    attributes: [:id, :question, :chat_id, :dt],
    type: :ordered_set,
    autoincrement: true
end
