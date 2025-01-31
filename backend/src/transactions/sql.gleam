import gleam/dynamic/decode
import gleam/option.{type Option}
import pog

/// A row you get from running the `insert_transaction` query
/// defined in `./src/transactions/sql/insert_transaction.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type InsertTransactionRow {
  InsertTransactionRow(id: Int)
}

/// Runs the `insert_transaction` query
/// defined in `./src/transactions/sql/insert_transaction.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_transaction(
  db,
  arg_1,
  arg_2,
  arg_3,
  arg_4,
  arg_5,
  arg_6,
  arg_7,
  arg_8,
  arg_9,
  arg_10,
  arg_11,
  arg_12,
  arg_13,
  arg_14,
  arg_15,
) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    decode.success(InsertTransactionRow(id:))
  }

  let query =
    "insert into transactions (
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
    amount,
    currency,
    bic,
    country_code,
    communications
) values (
    $1,  -- account (varchar(50))
    $2,  -- booking_date (date)
    $3,  -- statement_number (varchar(50))
    $4,  -- transaction_number (varchar(50))
    $5,  -- counterparty_account (varchar(50), nullable)
    $6,  -- counterparty_name (varchar(255), nullable)
    $7,  -- street_address (varchar(255), nullable)
    $8,  -- postal_code_city (varchar(100), nullable)
    $9,  -- transaction_type (varchar(50))
    $10, -- value_date (date)
    $11, -- amount (decimal(15,2))
    $12, -- currency (char(3))
    $13, -- bic (varchar(11), nullable)
    $14, -- country_code (char(2), nullable)
    $15  -- communications (text, nullable)
)
returning id
"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.date(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.text(arg_5))
  |> pog.parameter(pog.text(arg_6))
  |> pog.parameter(pog.text(arg_7))
  |> pog.parameter(pog.text(arg_8))
  |> pog.parameter(pog.text(arg_9))
  |> pog.parameter(pog.date(arg_10))
  |> pog.parameter(pog.float(arg_11))
  |> pog.parameter(pog.text(arg_12))
  |> pog.parameter(pog.text(arg_13))
  |> pog.parameter(pog.text(arg_14))
  |> pog.parameter(pog.text(arg_15))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_transactions` query
/// defined in `./src/transactions/sql/find_transactions.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTransactionsRow {
  FindTransactionsRow(
    id: Int,
    account: String,
    booking_date: pog.Date,
    statement_number: String,
    transaction_number: String,
    counterparty_account: Option(String),
    counterparty_name: Option(String),
    street_address: Option(String),
    postal_code_city: Option(String),
    transaction_type: String,
    value_date: pog.Date,
    amount: Float,
    currency: String,
    bic: Option(String),
    country_code: Option(String),
    communications: Option(String),
  )
}

/// Runs the `find_transactions` query
/// defined in `./src/transactions/sql/find_transactions.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_transactions(db) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use account <- decode.field(1, decode.string)
    use booking_date <- decode.field(2, pog.date_decoder())
    use statement_number <- decode.field(3, decode.string)
    use transaction_number <- decode.field(4, decode.string)
    use counterparty_account <- decode.field(5, decode.optional(decode.string))
    use counterparty_name <- decode.field(6, decode.optional(decode.string))
    use street_address <- decode.field(7, decode.optional(decode.string))
    use postal_code_city <- decode.field(8, decode.optional(decode.string))
    use transaction_type <- decode.field(9, decode.string)
    use value_date <- decode.field(10, pog.date_decoder())
    use amount <- decode.field(11, decode.float)
    use currency <- decode.field(12, decode.string)
    use bic <- decode.field(13, decode.optional(decode.string))
    use country_code <- decode.field(14, decode.optional(decode.string))
    use communications <- decode.field(15, decode.optional(decode.string))
    decode.success(FindTransactionsRow(
      id:,
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
  }

  let query =
    "select
  *
from
  transactions
"

  pog.query(query)
  |> pog.returning(decoder)
  |> pog.execute(db)
}
