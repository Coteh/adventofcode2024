import day01
import day02
import day03
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

fn read_day03_input() -> List(String) {
  case simplifile.read("input/day03/input") {
    Ok(file) -> {
      string.trim(file)
      |> string.split("\n")
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

pub fn day03_mul_single_test() {
  day03.process_lines(["mul(3,9)"], True)
  |> should.equal(27)
}

pub fn day03_mul_double_test() {
  day03.process_lines(["mul(3,9)mul(2,2)"], True)
  |> should.equal(31)
}

pub fn day03_mul_garbage_before_test() {
  day03.process_lines(["dsfdsfdsmul(3,9)"], True)
  |> should.equal(27)
}

pub fn day03_mul_garbage_after_test() {
  day03.process_lines(["mul(3,9)dsfdsfsd"], True)
  |> should.equal(27)
}

pub fn day03_mul_garbage_before_params_test() {
  day03.process_lines(["mul(dsfdsf3,9)"], True)
  |> should.equal(0)
}

pub fn day03_mul_garbage_between_params_test() {
  day03.process_lines(["mul(3,dsfdsf9)"], True)
  |> should.equal(0)
}

pub fn day03_mul_garbage_after_params_test() {
  day03.process_lines(["mul(3,9dsfdsf)"], True)
  |> should.equal(0)
}

pub fn day03_mul_nested_test() {
  day03.process_lines(["mul(3,mul(8,3))"], True)
  |> should.equal(24)
}

pub fn day03_mul_single_param_test() {
  day03.process_lines(["mul(3)"], True)
  |> should.equal(0)
}

pub fn day03_mul_no_param_test() {
  day03.process_lines(["mul()"], True)
  |> should.equal(0)
}

pub fn day03_mul_typo_test() {
  day03.process_lines(["mlu(3,9)"], True)
  |> should.equal(0)
}

pub fn day03_mul_sample_part1_test() {
  day03.process_lines(
    ["xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"],
    False,
  )
  |> should.equal(161)
}

pub fn day03_mul_sample_garbage_1_test() {
  day03.process_lines(["mul(4*"], True)
  |> should.equal(0)
}

pub fn day03_mul_sample_garbage_2_test() {
  day03.process_lines(["mul(6,9!"], True)
  |> should.equal(0)
}

pub fn day03_mul_sample_garbage_3_test() {
  day03.process_lines(["?(12,34)"], True)
  |> should.equal(0)
}

pub fn day03_mul_sample_garbage_4_test() {
  day03.process_lines(["mul ( 2 , 4 )"], True)
  |> should.equal(0)
}

pub fn day03_dont_test() {
  day03.process_lines(["mul(1,1)don't()mul(1,1)"], True)
  |> should.equal(1)
}

pub fn day03_dont_no_conditionals_test() {
  day03.process_lines(["mul(1,1)don't()mul(1,1)"], False)
  |> should.equal(2)
}

pub fn day03_do_test() {
  day03.process_lines(["mul(1,1)don't()do()mul(1,1)"], True)
  |> should.equal(2)
}

pub fn day03_do_no_conditionals_test() {
  day03.process_lines(["mul(1,1)don't()do()mul(1,1)"], False)
  |> should.equal(2)
}

pub fn day03_double_dont_test() {
  day03.process_lines(["mul(1,1)don't()don't()mul(1,1)"], True)
  |> should.equal(1)
}

pub fn day03_double_do_test() {
  day03.process_lines(["mul(1,1)do()do()mul(1,1)"], True)
  |> should.equal(2)
}

pub fn day03_do_then_dont_test() {
  day03.process_lines(["mul(1,1)do()don't()mul(1,1)"], True)
  |> should.equal(1)
}

pub fn day03_dont_garbage_before_param_test() {
  day03.process_lines(["mul(1,1)don'tdsfds()mul(1,1)"], True)
  |> should.equal(2)
}

pub fn day03_dont_garbage_in_param_test() {
  day03.process_lines(["mul(1,1)don't(dsfds)mul(1,1)"], True)
  |> should.equal(2)
}

pub fn day03_dont_garbage_after_param_test() {
  day03.process_lines(["mul(1,1)don't()dsfdsmul(1,1)"], True)
  |> should.equal(1)
}

pub fn day03_dont_typo_test() {
  day03.process_lines(["mul(1,1)dodsfdsn't()mul(1,1)"], True)
  |> should.equal(2)
}

pub fn day03_dont_nested_test() {
  day03.process_lines(["mul(1,1)don't(don't())mul(1,1)"], True)
  |> should.equal(1)
}

pub fn day03_dont_double_parentheses_test() {
  day03.process_lines(["mul(1,1)don't(()mul(1,1)"], True)
  |> should.equal(2)
}

pub fn day03_nested_mul_dont_do_test() {
  day03.process_lines(
    ["mul(1,1)mul(don't()2,3mul(4,5))mul(do()2,3mul(1,1))"],
    True,
  )
  |> should.equal(2)
}

pub fn day03_mul_sample_part2_test() {
  day03.process_lines(
    [
      "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))",
    ],
    True,
  )
  |> should.equal(48)
}

pub fn day03_part1_mul_input_part1_test() {
  read_day03_input()
  // |> io.debug
  |> day03.process_lines(False)
  |> should.equal(169_021_493)
}

pub fn day03_part1_mul_input_part2_test() {
  read_day03_input()
  // |> io.debug
  |> day03.process_lines(True)
  |> should.equal(111_762_583)
}
