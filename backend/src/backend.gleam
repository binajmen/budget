import envoy
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import parsers/amount
import parsers/csv
import pog
import simplifile
import transaction
import transactions/sql

pub fn read_connection_uri() -> Result(pog.Connection, Nil) {
  use database_url <- result.try(envoy.get("DATABASE_URL"))
  use config <- result.try(pog.url_config(database_url))
  Ok(pog.connect(config))
}

pub fn main() {
  let db = case read_connection_uri() {
    Ok(db) -> db
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

  use #(from_line, lines) <- result.try(csv.consume_line(lines))
  let from = case from_line {
    [_, from] -> from
    _ -> panic as "Invalid from line format"
  }

  use #(to_line, lines) <- result.try(csv.consume_line(lines))
  let to = case to_line {
    [_, to] -> to
    _ -> panic as "Invalid to line format"
  }

  use lines <- result.try(csv.skip_lines(lines, 7))
  use #(balance_line, lines) <- result.try(csv.consume_line(lines))
  let balance = case amount.parse_balance(balance_line) {
    Ok(amount) -> amount
    Error(_) -> panic as "Invalid amount format"
  }

  let assert Ok(res) = sql.find_transactions(db)
  io.debug(res)

  // let assert Ok(res) =
  //   sql.insert_transaction(
  //     db,
  //     "BE12",
  //     pog.Date(2025, 01, 31),
  //     "",
  //     "",
  //     "",
  //     "",
  //     "",
  //     "",
  //     "",
  //     pog.Date(2025, 01, 31),
  //     100.0,
  //     "",
  //     "",
  //     "",
  //     "",
  //   )
  // io.debug(res)

  use #(timestamp, lines) <- result.try(csv.consume_line(lines))
  use lines <- result.try(csv.skip_lines(lines, 2))

  let transactions =
    list.try_map(lines, fn(line) { transaction.handle_transaction(db, line) })

  io.debug(from)
  io.debug(to)
  io.debug(balance)
  io.debug(timestamp)
  io.debug(transactions)
}
