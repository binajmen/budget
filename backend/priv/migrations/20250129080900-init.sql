--- migration:up
create extension "uuid-ossp";

--- migration:down
drop extension "uuid-ossp";

--- migration:end
