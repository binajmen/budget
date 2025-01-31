insert into
  transactions (
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
  )
values
  (
    $1, -- account (varchar(50))
    $2, -- booking_date (date)
    $3, -- statement_number (varchar(5))
    $4, -- transaction_number (varchar(10))
    nullif($5, ''), -- counterparty_account (varchar(50), nullable)
    nullif($6, ''), -- counterparty_name (varchar(255), nullable)
    nullif($7, ''), -- street_address (varchar(255), nullable)
    nullif($8, ''), -- postal_code_city (varchar(100), nullable)
    nullif($9, ''), -- transaction_type (test, nullable)
    $10, -- value_date (date)
    $11, -- amount (decimal(15,2))
    $12, -- currency (char(3))
    nullif($13, ''), -- bic (varchar(11), nullable)
    nullif($14, ''), -- country_code (char(2), nullable)
    nullif($15, '') -- communications (text, nullable)
  )
returning
  id
