defmodule EbayClone.PriceValidation do
  use EbayClone.Web, :model

  def validate_positive_integer(changeset, field) do
    if number = get_change(changeset, field) do
      add_price_errors_to_changeset(changeset, field, number)
    else
      changeset
    end
  end

  defp add_price_errors_to_changeset(changeset, field, number) do
    if number < 0 do
      changeset
      |> add_error(field, "can't be a number less than 0")
    else
      changeset
    end
  end
end
