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

pub fn day02_report_part1_test() {
  day02.validate_report([7, 6, 4, 2, 1]) |> should.equal(True)
  day02.validate_report([1, 2, 7, 8, 9]) |> should.equal(False)
  day02.validate_report([9, 7, 6, 2, 1]) |> should.equal(False)
  day02.validate_report([1, 3, 2, 4, 5]) |> should.equal(False)
  day02.validate_report([8, 6, 4, 4, 1]) |> should.equal(False)
  day02.validate_report([1, 3, 6, 7, 9]) |> should.equal(True)
}

pub fn day02_report_part2_test() {
  // sample cases
  day02.validate_report_with_dampener([7, 6, 4, 2, 1]) |> should.equal(True)
  day02.validate_report_with_dampener([1, 2, 7, 8, 9]) |> should.equal(False)
  day02.validate_report_with_dampener([9, 7, 6, 2, 1]) |> should.equal(False)
  day02.validate_report_with_dampener([1, 3, 2, 4, 5]) |> should.equal(True)
  day02.validate_report_with_dampener([8, 6, 4, 4, 1]) |> should.equal(True)
  day02.validate_report_with_dampener([1, 3, 6, 7, 9]) |> should.equal(True)

  // empty case
  day02.validate_report_with_dampener([]) |> should.equal(True)
  // single value case
  day02.validate_report_with_dampener([1]) |> should.equal(True)
  // right side case (remove decrease)
  day02.validate_report_with_dampener([1, 2, 3, 4, 3]) |> should.equal(True)
  // right side case (remove steep decrease)
  day02.validate_report_with_dampener([3, 4, 5, 6, 1]) |> should.equal(True)
  // left side case (remove decrease)
  day02.validate_report_with_dampener([3, 1, 2, 3, 4]) |> should.equal(True)
  // left side case (remove steep decrease)
  day02.validate_report_with_dampener([9, 1, 2, 3, 4]) |> should.equal(True)
  // right side case (remove increase)
  day02.validate_report_with_dampener([4, 3, 2, 1, 2]) |> should.equal(True)
  // right side case (remove steep increase)
  day02.validate_report_with_dampener([4, 3, 2, 1, 9]) |> should.equal(True)
  // left side case (remove increase)
  day02.validate_report_with_dampener([8, 9, 8, 7, 6]) |> should.equal(True)
  // left side case (remove steep increase)
  day02.validate_report_with_dampener([1, 9, 8, 7, 6]) |> should.equal(True)
  // left side case (remove same value)
  day02.validate_report_with_dampener([1, 1, 2, 3, 4]) |> should.equal(True)
  // right side case (remove same value)
  day02.validate_report_with_dampener([1, 2, 3, 4, 4]) |> should.equal(True)
  // cannot recover case
  day02.validate_report_with_dampener([1, 3, 7, 8, 9]) |> should.equal(False)
  // middle case (remove same value)
  day02.validate_report_with_dampener([1, 2, 2, 3, 4]) |> should.equal(True)
  // middle case (remove steep increase/decrease)
  day02.validate_report_with_dampener([1, 2, 7, 3, 4]) |> should.equal(True)
  // middle case (remove steep decrease/increase)
  day02.validate_report_with_dampener([9, 8, 1, 7, 6]) |> should.equal(True)
  // middle case (remove decrease)
  day02.validate_report_with_dampener([1, 2, 5, 3, 4]) |> should.equal(True)
  // middle case (remove increase)
  day02.validate_report_with_dampener([4, 3, 4, 2, 1]) |> should.equal(True)
}

pub fn day02_reports_input_part1_test() {
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

pub fn day02_reports_input_part2_test() {
  read_day02_input()
  |> list.map(day02.validate_report_with_dampener)
  |> list.fold(0, fn(acc, is_safe) {
    case is_safe {
      True -> acc + 1
      False -> acc
    }
  })
  |> should.equal(400)
}
