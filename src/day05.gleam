import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type InputReadState {
  Rules
  Inputs
}

pub fn process_rule(line: String) -> #(Int, Int) {
  let split_nums =
    string.split(line, "|")
    |> list.map(fn(x) { int.parse(x) |> result.unwrap(0) })
  let first = list.first(split_nums) |> result.unwrap(0)
  let last = list.last(split_nums) |> result.unwrap(0)

  #(first, last)
}

pub fn process_inputs(line: String) -> List(Int) {
  string.split(line, ",")
  |> list.map(fn(x) { int.parse(x) |> result.unwrap(0) })
}

fn read_lines(acc: List(String)) -> #(List(#(Int, Int)), List(List(Int))) {
  case erlang.get_line("") {
    Ok(line) -> {
      let trimmed_line = string.trim(line)
      read_lines([trimmed_line, ..acc])
    }
    Error(_) -> {
      let split_inputs =
        list.reverse(acc)
        |> list.split_while(fn(line) { line != "" })

      let processed_rules = list.map(split_inputs.0, process_rule)
      let processed_inputs =
        list.map(
          split_inputs.1 |> list.rest() |> result.unwrap([]),
          process_inputs,
        )

      #(processed_rules, processed_inputs)
    }
  }
}

fn generate_all_possible_rules(line: List(Int)) -> List(#(Int, Int)) {
  line
  |> list.index_map(fn(x, i) { #(i, x) })
  |> list.flat_map(fn(tup) {
    let i = tup.0
    let x = tup.1
    line
    |> list.index_map(fn(y, j) { #(j, y) })
    |> list.filter_map(fn(tup2) {
      let j = tup2.0
      let y = tup2.1
      case i < j {
        True -> Ok(#(x, y))
        False -> Error(#())
      }
    })
  })
}

pub fn evaluate_line(line: List(Int), rules: List(#(Int, Int))) -> Bool {
  let results =
    generate_all_possible_rules(line)
    |> list.map(fn(possible_rule) {
      rules
      |> list.find(fn(rule) { rule == possible_rule })
    })

  results
  |> list.all(fn(result) {
    case result {
      Ok(_) -> True
      Error(_) -> False
    }
  })
}

pub fn find_middle_page(line: List(Int)) -> Int {
  let list_len = line |> list.length()
  let middle_index = list_len / 2

  let found =
    line
    |> list.index_map(fn(x, i) { #(i, x) })
    |> list.find(fn(tup) {
      let i = tup.0

      i == middle_index
    })
    |> result.unwrap(#(-1, -1))

  found.1
}

pub fn main() {
  let #(rules, lines) = read_lines([])

  lines
  |> list.filter_map(fn(line) {
    let valid = evaluate_line(line, rules)

    case valid {
      True -> Ok(find_middle_page(line))
      False -> Error(0)
    }
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> io.debug
}
