import gleam/int
import gleam/string
import pog

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
