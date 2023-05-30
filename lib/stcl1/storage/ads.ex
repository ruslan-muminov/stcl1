defmodule Stcl1.Storage.Ads do
  use Memento.Table,
    attributes: [:id, :send_dt, :text, :status]

  # status: :wait | :done
end
