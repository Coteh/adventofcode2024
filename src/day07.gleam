import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

fn read_lines(acc: List(String)) -> List(#(Int, List(Int))) {
  case erlang.get_line("") {
    Ok(line) -> {
      let trimmed_line = string.trim(line)
      read_lines([trimmed_line, ..acc])
    }
    Error(_) ->
      list.reverse(acc)
      |> list.map(fn(line) { line |> string.split(" ") })
      |> list.map(fn(num_strs) {
        let first = list.first(num_strs) |> result.unwrap("0")
        let rest = list.rest(num_strs) |> result.unwrap([])

        #(
          int.parse(first |> string.drop_end(1)) |> result.unwrap(0),
          list.map(rest, fn(x) { int.parse(x) |> result.unwrap(0) }),
        )
      })
  }
}

fn iterate_operation(
  expected_result: Int,
  curr_result: Int,
  curr_list: List(Int),
  use_concat: Bool,
) -> Int {
  case curr_list {
    [first, ..rest] -> {
      let add_result =
        iterate_operation(
          expected_result,
          curr_result + first,
          rest,
          use_concat,
        )
      case add_result == expected_result {
        True -> add_result
        False -> {
          let mul_result =
            iterate_operation(
              expected_result,
              curr_result * first,
              rest,
              use_concat,
            )
          case mul_result == expected_result {
            True -> mul_result
            False -> {
              case use_concat {
                True -> {
                  let concat_str =
                    int.to_string(curr_result) <> int.to_string(first)
                  let concat_result =
                    concat_str
                    |> int.parse
                    |> result.unwrap(0)
                    |> iterate_operation(expected_result, _, rest, use_concat)
                  case concat_result == expected_result {
                    True -> concat_result
                    False -> 0
                  }
                }
                False -> 0
              }
            }
          }
        }
      }
    }
    [] -> curr_result
  }
}

pub fn determine_correct_operation(
  equation: #(Int, List(Int)),
  use_concat: Bool,
) -> Int {
  iterate_operation(equation.0, 0, equation.1, use_concat)
}

pub fn main() {
  let equations = read_lines([])

  equations
  //   |> io.debug
  |> list.map(determine_correct_operation(_, False))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> io.debug

  equations
  // |> io.debug
  |> list.map(determine_correct_operation(_, True))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> io.debug
}
