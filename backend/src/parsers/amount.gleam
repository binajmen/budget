import gleam/float
import gleam/string

pub fn parse_amount(amount_str: String) -> Result(Float, String) {
  case
    amount_str
    |> string.replace(".", "")
    |> string.replace(",", ".")
    |> float.parse
  {
    Ok(value) -> Ok(value)
    Error(_) -> Error("Invalid amount format")
  }
}

pub fn parse_balance(line: List(String)) -> Result(Float, String) {
  case line {
    ["Dernier solde", amount_str] -> {
      case
        amount_str
        |> string.replace(" EUR", "")
        |> string.replace(".", "")
        |> string.replace(",", ".")
        |> float.parse
      {
        Ok(amount) -> Ok(amount)
        Error(_) -> Error("Invalid balance format")
      }
    }
    _ -> Error("Invalid balance line format")
  }
}
