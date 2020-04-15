defmodule Timestamp do
  use Ecto.Type

  def type, do: :utc_datetime

  def cast(epoch) when is_integer(epoch) do
    case DateTime.from_unix(epoch) do
      {:error, _} -> :error
      result -> result
    end
  end

  def cast(_), do: :error

  def load(%DateTime{} = data),
    do: {:ok, data}

  def load(_),
    do: :error

  def dump(%DateTime{} = datetime),
    do: {:ok, datetime}

  def dump(_), do: :error
end
