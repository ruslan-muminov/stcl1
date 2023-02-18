defmodule Stcl1.Storage.ButtonLog do
  use Memento.Table,
    attributes: [:button_name, :count]
end
