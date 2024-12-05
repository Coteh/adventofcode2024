import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub type ReadState {
  Initial
  Param(index: Int)
}

fn read_lines(acc: List(String)) -> List(String) {
  case erlang.get_line("") {
    Ok(line) -> {
      let trimmed_line = string.trim(line)
      read_lines([trimmed_line, ..acc])
    }
    Error(_) -> list.reverse(acc)
  }
}

pub fn process_line(line: String) -> Int {
  let characters = string.split(line, "")
  let result =
    list.fold(characters, #("", Initial, 0), fn(tup, chr) {
      let acc = tup.0
      let curr_read_state = tup.1
      let x = tup.2

      // io.debug("acc")
      // io.debug(acc)
      case chr {
        "m" -> {
          case curr_read_state {
            Initial -> #(acc <> chr, Initial, x)
            Param(_) -> #("m", Initial, x)
          }
        }
        "u" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "m" -> #(acc <> chr, Initial, x)
                _ -> #("", Initial, x)
              }
            }
            Param(_) -> #("", Initial, x)
          }
        }
        "l" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "mu" -> #(acc <> chr, Initial, x)
                _ -> #("", Initial, x)
              }
            }
            Param(_) -> #("", Initial, x)
          }
        }
        "(" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "mul" -> #("", Param(1), x)
                _ -> #("", Initial, x)
              }
            }
            Param(_) -> #("", Initial, x)
          }
        }
        ")" -> {
          case curr_read_state {
            Initial -> #("", Initial, x)
            Param(index) -> {
              case index {
                1 -> #("", Initial, x)
                _ -> {
                  let split_nums =
                    string.split(acc, ",")
                    |> list.map(int.parse)
                    |> list.map(fn(num_str) {
                      case num_str {
                        Ok(val) -> val
                        Error(_) -> 0
                      }
                    })
                  case list.reduce(split_nums, fn(acc, y) { y * acc }) {
                    Ok(val) -> #("", Initial, x + val)
                    Error(Nil) -> #("", Initial, x)
                  }
                }
              }
            }
          }
        }
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
          case curr_read_state {
            Initial -> #("", Initial, x)
            Param(_) -> #(acc <> chr, curr_read_state, x)
          }
        }
        "," -> {
          case curr_read_state {
            Initial -> #("", Initial, x)
            Param(i) -> #(acc <> chr, Param(i + 1), x)
          }
        }
        _ -> #("", Initial, x)
      }
    })
  result.2
}

pub fn main() {
  let lines = read_lines([])

  lines
  // |> io.debug
  |> list.map(process_line)
  |> list.reduce(fn(acc, x) { acc + x })
  |> fn(x) {
    case x {
      Ok(val) -> val
      Error(_) -> 0
    }
  }
  |> io.debug
}
