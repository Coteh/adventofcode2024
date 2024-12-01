import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import gleam/io
import gleam/erlang

fn read_lines(acc: List(String)) -> List(String) {
  case erlang.get_line("") {
    Ok(line) -> {
      let trimmed_line = string.trim(line)
      read_lines([trimmed_line, ..acc])
    }
    Error(_) -> list.reverse(acc)
  }
}

pub fn calculate_total_distance(split_lines: List(List(Int))) -> Int {
  let group1 = list.map(split_lines, fn (x) { 
    case list.first(x) {
      Ok(val) -> {
        val
      }
      Error(_) -> 0
    }
  }) |> list.sort(int.compare)
  let group2 = list.map(split_lines, fn (x) { 
    case list.last(x) {
      Ok(val) -> {
        val
      }
      Error(_) -> 0
    }
  }) |> list.sort(int.compare)
  let distances = group1 |> list.zip(group2) |> list.map(fn (x) { int.absolute_value(x.1 - x.0) })
  case distances |> list.reduce(fn (acc, x) { acc + x }) {
    Ok(val) -> {
      val
    }
    Error(_) -> 0
  }
}

pub fn calculate_similarity_score(split_lines: List(List(Int))) -> Int {
  let group1 = list.map(split_lines, fn (x) { 
    case list.first(x) {
      Ok(val) -> {
        val
      }
      Error(_) -> 0
    }
  })
  let group2 = list.map(split_lines, fn (x) { 
    case list.last(x) {
      Ok(val) -> {
        val
      }
      Error(_) -> 0
    }
  })
  let frequencies = list.fold(group2, dict.new(), fn (curr_dict, val) {
    let curr_val = case dict.get(curr_dict, val) {
      Ok(freq) -> freq
      Error(_) -> 0
    }
    dict.insert(curr_dict, val, curr_val + 1)
  })
  let similarities = group1 |> list.map(fn (x) {
    let frequency = case dict.get(frequencies, x) {
      Ok(val) -> val
      Error(_) -> 0
    }
    x * frequency
  })
  case list.reduce(similarities, fn (acc, x) { acc + x }) {
    Ok(val) -> {
      val
    }
    Error(_) -> 0
  }
}

pub fn main() {
  let lines = read_lines([])
  let split_lines = list.map(lines, fn (line: String) { 
    string.split(line, on: "   ") |> list.map(fn (str_val) {
      case int.parse(str_val) {
        Ok(val) -> {
          val
        }
        Error(_) -> 0
      }
    })
  })
  
  let total_dist = calculate_total_distance(split_lines)
  io.debug(total_dist)

  let similarity_score = calculate_similarity_score(split_lines)
  io.debug(similarity_score)
}
