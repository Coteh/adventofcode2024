import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub type ReadState {
  Initial
  Param(index: Int)
}

pub type MulState {
  Enabled
  Disabled
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

fn process_line(
  line: String,
  mul_enabled: MulState,
  use_conditionals: Bool,
) -> #(Int, MulState) {
  let characters = string.split(line, "")
  let result =
    list.fold(characters, #("", Initial, 0, mul_enabled, ""), fn(tup, chr) {
      let acc = tup.0
      let curr_read_state = tup.1
      let x = tup.2
      let mul_state = tup.3
      let command = tup.4

      case chr {
        "m" -> {
          case curr_read_state {
            Initial -> #(acc <> chr, Initial, x, mul_state, "")
            Param(_) -> #("m", Initial, x, mul_state, "")
          }
        }
        "u" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "m" -> #(acc <> chr, Initial, x, mul_state, "")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        "l" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "mu" -> #(acc <> chr, Initial, x, mul_state, "")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        "(" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "mul" -> #("", Param(1), x, mul_state, "mul")
                "do" -> #("", Param(1), x, mul_state, "do")
                "don't" -> #("", Param(1), x, mul_state, "don't")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        ")" -> {
          case curr_read_state {
            Initial -> #("", Initial, x, mul_state, "")
            Param(index) -> {
              case index {
                1 -> {
                  case command {
                    "do" -> #("", Initial, x, Enabled, "")
                    "don't" -> {
                      case use_conditionals {
                        True -> #("", Initial, x, Disabled, "")
                        False -> #("", Initial, x, mul_state, "")
                      }
                    }
                    _ -> #("", Initial, x, mul_state, "")
                  }
                }
                _ -> {
                  case command {
                    "mul" -> {
                      case mul_state {
                        Enabled -> {
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
                            Ok(val) -> #("", Initial, x + val, mul_state, "")
                            Error(Nil) -> #("", Initial, x, mul_state, "")
                          }
                        }
                        Disabled -> #("", Initial, x, Disabled, "")
                      }
                    }
                    _ -> #("", Initial, x, mul_state, "")
                  }
                }
              }
            }
          }
        }
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
          case curr_read_state {
            Initial -> #("", Initial, x, mul_state, "")
            Param(_) -> {
              case command {
                "mul" -> #(acc <> chr, curr_read_state, x, mul_state, command)
                _ -> #("", Initial, x, mul_state, "")
              }
            }
          }
        }
        "," -> {
          case curr_read_state {
            Initial -> #("", Initial, x, mul_state, "")
            Param(i) -> #(acc <> chr, Param(i + 1), x, mul_state, command)
          }
        }
        "d" -> {
          case curr_read_state {
            Initial -> #(acc <> chr, Initial, x, mul_state, "")
            Param(_) -> #("d", Initial, x, mul_state, "")
          }
        }
        "o" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "d" -> #(acc <> chr, Initial, x, mul_state, "")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        "n" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "do" -> #(acc <> chr, Initial, x, mul_state, "")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        "'" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "don" -> #(acc <> chr, Initial, x, mul_state, "")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        "t" -> {
          case curr_read_state {
            Initial -> {
              case acc {
                "don'" -> #(acc <> chr, Initial, x, mul_state, "")
                _ -> #("", Initial, x, mul_state, "")
              }
            }
            Param(_) -> #("", Initial, x, mul_state, "")
          }
        }
        _ -> #("", Initial, x, mul_state, "")
      }
    })
  #(result.2, result.3)
}

pub fn process_lines(lines: List(String), use_conditionals: Bool) -> Int {
  let result =
    lines
    |> list.fold(#(0, Enabled), fn(acc, line) {
      let result = process_line(line, acc.1, use_conditionals)

      #(acc.0 + result.0, result.1)
    })

  result.0
}

pub fn main() {
  let lines = read_lines([])

  lines
  // |> io.debug
  |> process_lines(False)
  |> io.debug

  lines
  // |> io.debug
  |> process_lines(True)
  |> io.debug
}
