--- migration:up
create table if not exists transactions (
  -- primary key using a combination of statement and transaction numbers
  id serial primary key,
  account varchar(50) not null,
  booking_date date not null,
  statement_number varchar(5),
  transaction_number varchar(10),
  counterparty_account varchar(50),
  counterparty_name varchar(255),
  street_address varchar(255),
  postal_code_city varchar(100),
  transaction_type text,
  value_date date not null,
  amount decimal(15, 2) not null,
  currency char(3) not null,
  bic varchar(11),
  country_code char(2),
  communications text
  -- add constraints
  -- constraint unique_transaction unique (statement_number, transaction_number),
  -- constraint check_currency check (currency ~ '^[A-Z]{3}$'),
  -- constraint check_country_code check (country_code ~ '^[A-Z]{2}$'),
  -- constraint check_bic check (bic ~ '^[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3})?$')
);

-- create index for common queries
create index idx_booking_date on transactions (booking_date);

create index idx_value_date on transactions (value_date);

create index idx_account on transactions (account);

create index idx_counterparty_account on transactions (counterparty_account);

--- migration:down
drop index if exists idx_booking_date;

drop index if exists idx_value_date;

drop index if exists idx_account;

drop index if exists idx_counterparty_account;

drop table if exists transactions;

--- migration:end
