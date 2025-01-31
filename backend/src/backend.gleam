import envoy
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import pog
import simplifile
import transactions/sql

fn split_line(line: String) -> List(String) {
  string.split(line, on: ";")
  |> list.map(string.trim)
}

fn consume_line(
  lines: List(String),
) -> Result(#(List(String), List(String)), String) {
  case lines {
    [line, ..rest] -> Ok(#(split_line(line), rest))
    [] -> Error("No more lines to consume")
  }
}

fn skip_lines(lines: List(String), count: Int) -> Result(List(String), String) {
  case count {
    0 -> Ok(lines)
    n if n > 0 -> {
      case lines {
        [_, ..rest] -> skip_lines(rest, n - 1)
        [] -> Error("No more lines to skip")
      }
    }
    _ -> Error("Count must be non-negative")
  }
}

pub type Transaction {
  Transaction(
    account: String,
    booking_date: String,
    statement_number: String,
    transaction_number: String,
    counterparty_account: String,
    counterparty_name: String,
    street_address: String,
    postal_code_city: String,
    transaction_type: String,
    value_date: String,
    amount: Float,
    currency: String,
    bic: String,
    country_code: String,
    communications: String,
  )
}

fn parse_amount(amount_str: String) -> Result(Float, String) {
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

fn line_to_transaction(line: String) -> Result(Transaction, String) {
  case split_line(line) {
    [
      account,
      booking_date,
      statement_number,
      transaction_number,
      counterparty_account,
      counterparty_name,
      street_address,
      postal_code_city,
      transaction_type,
      value_date,
      amount_str,
      currency,
      bic,
      country_code,
      communications,
    ] -> {
      case parse_amount(amount_str) {
        Ok(amount) ->
          Ok(Transaction(
            account:,
            booking_date:,
            statement_number:,
            transaction_number:,
            counterparty_account:,
            counterparty_name:,
            street_address:,
            postal_code_city:,
            transaction_type:,
            value_date:,
            amount:,
            currency:,
            bic:,
            country_code:,
            communications:,
          ))

        Error(error) -> Error(error)
      }
    }
    _ -> Error("Invalid line format")
  }
}

pub fn handle_transaction(pog: pog.Connection, line: String) {
  case line_to_transaction(line) {
    Ok(tx) -> {
      io.debug(tx)
      use booking_date <- result.try(parse_date(tx.booking_date))
      use value_date <- result.try(parse_date(tx.value_date))

      case
        sql.insert_transaction(
          pog,
          tx.account,
          booking_date,
          tx.statement_number,
          tx.transaction_number,
          tx.counterparty_account,
          tx.counterparty_name,
          tx.street_address,
          tx.postal_code_city,
          tx.transaction_type,
          value_date,
          tx.amount,
          tx.currency,
          tx.bic,
          tx.country_code,
          tx.communications,
        )
      {
        Ok(inserted) -> Ok(inserted)
        Error(err) ->
          Error("Failed to insert transaction: " <> string.inspect(err))
      }
    }

    Error(err) -> Error(err)
  }
}

fn parse_balance(line: List(String)) -> Result(Float, String) {
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

pub fn read_connection_uri() -> Result(pog.Connection, Nil) {
  use database_url <- result.try(envoy.get("DATABASE_URL"))
  use config <- result.try(pog.url_config(database_url))
  Ok(pog.connect(config))
}

pub fn parse_date(date: String) -> Result(pog.Date, String) {
  case string.split(date, on: "/") {
    [year, month, day] -> {
      case int.parse(year), int.parse(month), int.parse(day) {
        Ok(y), Ok(m), Ok(d) -> Ok(pog.Date(y, m, d))
        _, _, _ -> Error("Could not parse date parts as integers")
      }
    }
    _ -> Error("Invalid date format. Expected YYYY/MM/DD")
  }
}

pub fn main() {
  let pog = case read_connection_uri() {
    Ok(pog) -> pog
    Error(_) -> panic as "Faild to read connection uri"
  }

  let filepath = "./input.csv"

  let lines =
    case simplifile.read(filepath) {
      Ok(file) -> file
      Error(_) ->
        panic as "Something went wrong. Do you have an input.csv file in the root folder?"
    }
    |> string.split(on: "\n")
    |> list.filter(fn(line) { string.trim(line) != "" })

  use #(from_line, lines) <- result.try(consume_line(lines))
  let from = case from_line {
    [_, from] -> from
    _ -> panic as "Invalid from line format"
  }

  use #(to_line, lines) <- result.try(consume_line(lines))
  let to = case to_line {
    [_, to] -> to
    _ -> panic as "Invalid to line format"
  }

  use lines <- result.try(skip_lines(lines, 7))
  use #(balance_line, lines) <- result.try(consume_line(lines))
  let balance = case parse_balance(balance_line) {
    Ok(amount) -> amount
    Error(_) -> panic as "Invalid amount format"
  }

  use #(timestamp, lines) <- result.try(consume_line(lines))
  use lines <- result.try(skip_lines(lines, 2))
  let transactions =
    list.try_map(lines, fn(line) { handle_transaction(pog, line) })

  let assert Ok(res) = sql.find_transactions(pog)

  io.debug(res)
  io.debug(from)
  io.debug(to)
  io.debug(balance)
  io.debug(timestamp)
  io.debug(transactions)
}
