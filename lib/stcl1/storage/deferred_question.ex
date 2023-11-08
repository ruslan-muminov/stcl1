defmodule Stcl1.Storage.DeferredQuestion do
  use Memento.Table, attributes: [:question, :dt]
end
