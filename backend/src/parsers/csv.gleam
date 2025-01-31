import gleam/list
import gleam/string

pub fn split_line(line: String) -> List(String) {
  string.split(line, on: ";")
  |> list.map(string.trim)
}

pub fn consume_line(
  lines: List(String),
) -> Result(#(List(String), List(String)), String) {
  case lines {
    [line, ..rest] -> Ok(#(split_line(line), rest))
    [] -> Error("No more lines to consume")
  }
}

pub fn skip_lines(
  lines: List(String),
  count: Int,
) -> Result(List(String), String) {
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
