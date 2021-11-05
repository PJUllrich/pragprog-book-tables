defmodule MeowWeb.MeowView do
  use MeowWeb, :view

  def format_age(age_in_days) do
    years = div(age_in_days, 365)
    months = age_in_days |> rem(365) |> div(30)

    "#{years}y #{months}m"
  end

  def format_height(height_in_mm) do
    height_in_cm = height_in_mm / 100.0
    "#{height_in_cm}cm"
  end
end
