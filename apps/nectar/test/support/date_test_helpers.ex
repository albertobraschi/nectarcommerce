defmodule Nectar.DateTestHelpers do
  def get_past_date(days \\ 1) do
    {:ok, {y,m,d}} = Ecto.Date.dump(get_current_date)
    # Not safe as would fail on edge dates :(
    {:ok, prev_date} =
      :calendar.gregorian_days_to_date(:calendar.date_to_gregorian_days({y,m,d}) - days)
      |> Ecto.Date.load
    prev_date
  end

  def get_current_date do
    Ecto.Date.utc
  end

  def get_future_date(days \\ 1) do
    {:ok, {y,m,d}} = Ecto.Date.dump(get_current_date)
    # Not safe as would fail on edge dates :(
    {:ok, next_date} =
      :calendar.gregorian_days_to_date(:calendar.date_to_gregorian_days({y,m,d}) + days)
      |> Ecto.Date.load
    next_date
  end
end
