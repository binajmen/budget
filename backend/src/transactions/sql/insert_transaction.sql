insert into transactions (
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
