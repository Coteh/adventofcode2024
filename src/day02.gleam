import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/string

fn read_lines(acc: List(String)) -> List(String) {
  case erlang.get_line("") {
    Ok(line) -> {
      let trimmed_line = string.trim(line)
      read_lines([trimmed_line, ..acc])
    }
    Error(_) -> list.reverse(acc)
  }
}

pub fn validate_report_inner(
  report_rest: List(Int),
  prev: Int,
  diff: Int,
) -> Bool {
  case report_rest {
    [first, ..rest] -> {
      let new_diff = first - prev
      case
        new_diff == 0
        || new_diff > 0
        && diff < 0
        || new_diff < 0
        && diff > 0
        || int.absolute_value(new_diff) < 1
        || int.absolute_value(new_diff) > 3
      {
        True -> False
        False -> validate_report_inner(rest, first, new_diff)
      }
    }
    [] -> True
  }
}

pub fn validate_report(report: List(Int)) -> Bool {
  case report {
    [first, ..rest] -> {
      validate_report_inner(rest, first, 0)
    }
    [] -> True
  }
}

// brute forced it :)
pub fn validate_report_with_dampener(report: List(Int)) -> Bool {
  case report {
    [_, ..] -> {
      let list_copy = list.append(report, [])
      let index_list = list.index_map(list_copy, fn(_, i) { i })
      list.any(index_list, fn(i) {
        let list_before = list.take(list_copy, i)
        let list_after = list.drop(list_copy, i + 1)
        validate_report(list.append(list_before, list_after))
      })
    }
    [] -> True
  }
}

pub fn main() {
  let reports =
    read_lines([])
    |> list.map(fn(line) {
      string.split(line, " ")
      |> list.map(fn(item) {
        case int.parse(item) {
          Ok(val) -> val
          Error(_) -> 0
        }
      })
    })

  //   reports |> list.each(io.debug)

  io.debug(
    reports
    |> list.map(validate_report)
    |> list.fold(0, fn(acc, is_safe) {
      case is_safe {
        True -> acc + 1
        False -> acc
      }
    }),
  )

  io.debug(
    reports
    |> list.map(validate_report_with_dampener)
    |> list.fold(0, fn(acc, is_safe) {
      case is_safe {
        True -> acc + 1
        False -> acc
      }
    }),
  )
}
