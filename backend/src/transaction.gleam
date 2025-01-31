import gleam/result
import gleam/string
import parsers/amount
import parsers/csv
import parsers/date
import pog
import transactions/sql

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

pub fn line_to_transaction(line: String) -> Result(Transaction, String) {
  case csv.split_line(line) {
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
      case amount.parse_amount(amount_str) {
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
      use booking_date <- result.try(date.parse_date(tx.booking_date))
      use value_date <- result.try(date.parse_date(tx.value_date))

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
