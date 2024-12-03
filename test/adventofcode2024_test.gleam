import day01
import day02
import gleam/int
import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

fn read_day01_input() -> List(List(Int)) {
  case simplifile.read("input/day01/input") {
    Ok(file) ->
      string.trim(file)
      |> string.split("\n")
      |> list.map(fn(str_val) {
        string.split(str_val, "   ")
        |> list.map(fn(x) {
          case int.parse(x) {
            Ok(val) -> val
            Error(_) -> 0
          }
        })
      })
    Error(_) -> []
  }
}

fn read_day02_input() -> List(List(Int)) {
  case simplifile.read("input/day02/input") {
    Ok(file) -> {
      string.trim(file)
      |> string.split("\n")
      |> list.map(fn(line) {
        string.split(line, " ")
        |> list.map(fn(item) {
          case int.parse(item) {
            Ok(val) -> val
            Error(_) -> 0
          }
        })
      })
    }
    Error(_) -> []
  }
}

pub fn day01_distance_test() {
  day01.calculate_total_distance([
    [3, 4],
    [4, 3],
    [2, 5],
    [1, 3],
    [3, 9],
    [3, 3],
  ])
  |> should.equal(11)

  day01.calculate_total_distance([[3, 4], [10, 9]])
  |> should.equal(2)

  day01.calculate_total_distance(read_day01_input())
  |> should.equal(2_192_892)
}

pub fn day01_similarity_test() {
  day01.calculate_similarity_score([
    [3, 4],
    [4, 3],
    [2, 5],
    [1, 3],
    [3, 9],
    [3, 3],
  ])
  |> should.equal(31)

  day01.calculate_similarity_score([[3, 4], [10, 9]])
  |> should.equal(0)

  day01.calculate_similarity_score(read_day01_input())
  |> should.equal(22_962_826)
}

pub fn day02_report_test() {
  day02.validate_report([7, 6, 4, 2, 1]) |> should.equal(True)
  day02.validate_report([1, 2, 7, 8, 9]) |> should.equal(False)
  day02.validate_report([9, 7, 6, 2, 1]) |> should.equal(False)
  day02.validate_report([1, 3, 2, 4, 5]) |> should.equal(False)
  day02.validate_report([8, 6, 4, 4, 1]) |> should.equal(False)
  day02.validate_report([1, 3, 6, 7, 9]) |> should.equal(True)
}

pub fn day02_reports_input_test() {
  read_day02_input()
  |> list.map(day02.validate_report)
  |> list.fold(0, fn(acc, is_safe) {
    case is_safe {
      True -> acc + 1
      False -> acc
    }
  })
  |> should.equal(334)
}
