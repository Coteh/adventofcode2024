import day01
import day02
import day03
import day05
import day06
import day07
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
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

fn read_day05_input() -> #(List(#(Int, Int)), List(List(Int))) {
  let unprocessed_lines = case simplifile.read("input/day05/input") {
    Ok(file) -> {
      string.trim(file)
      |> string.split("\n")
      |> list.split_while(fn(line) { line != "" })
    }
    Error(_) -> #([], [])
  }

  let processed_rules = list.map(unprocessed_lines.0, day05.process_rule)
  let processed_inputs =
    list.map(
      unprocessed_lines.1 |> list.rest() |> result.unwrap([]),
      day05.process_inputs,
    )

  #(processed_rules, processed_inputs)
}

fn read_day06_input() -> day06.GuardMap {
  case simplifile.read("input/day06/input") {
    Ok(file) -> {
      string.trim(file)
      |> string.split("\n")
    }
    Error(_) -> []
  }
  |> day06.initialize_guard_map
}

fn read_day07_input() -> List(#(Int, List(Int))) {
  case simplifile.read("input/day07/input") {
    Ok(file) -> {
      string.trim(file)
      |> string.split("\n")
      |> list.map(fn(line) { line |> string.split(" ") })
    }
    Error(_) -> []
  }
  |> list.map(fn(num_strs) {
    let first = list.first(num_strs) |> result.unwrap("0")
    let rest = list.rest(num_strs) |> result.unwrap([])

    #(
      int.parse(first |> string.drop_end(1)) |> result.unwrap(0),
      list.map(rest, fn(x) { int.parse(x) |> result.unwrap(0) }),
    )
  })
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

pub fn day05_filter_rules_test() {
  let rules = [
    #(47, 53),
    #(97, 13),
    #(97, 61),
    #(97, 47),
    #(75, 29),
    #(61, 13),
    #(75, 53),
    #(29, 13),
    #(97, 29),
    #(53, 29),
    #(61, 53),
    #(97, 53),
    #(61, 29),
    #(47, 13),
    #(75, 47),
    #(97, 75),
    #(47, 61),
    #(75, 61),
    #(47, 29),
    #(75, 13),
    #(53, 13),
  ]
  let line = [75, 29, 13]
  day05.filter_rules(rules, line)
  |> should.equal([
    #(97, 13),
    #(75, 29),
    #(61, 13),
    #(75, 53),
    #(29, 13),
    #(97, 29),
    #(53, 29),
    #(61, 29),
    #(47, 13),
    #(75, 47),
    #(97, 75),
    #(75, 61),
    #(47, 29),
    #(75, 13),
    #(53, 13),
  ])
}

pub fn day05_part1_sample_test() {
  let #(rules, lines) = #(
    [
      #(47, 53),
      #(97, 13),
      #(97, 61),
      #(97, 47),
      #(75, 29),
      #(61, 13),
      #(75, 53),
      #(29, 13),
      #(97, 29),
      #(53, 29),
      #(61, 53),
      #(97, 53),
      #(61, 29),
      #(47, 13),
      #(75, 47),
      #(97, 75),
      #(47, 61),
      #(75, 61),
      #(47, 29),
      #(75, 13),
      #(53, 13),
    ],
    [
      [75, 47, 61, 53, 29],
      [97, 61, 53, 29, 13],
      [75, 29, 13],
      [75, 97, 47, 61, 53],
      [61, 13, 29],
      [97, 13, 75, 29, 47],
    ],
  )

  lines
  |> list.filter_map(fn(line) {
    let valid = day05.evaluate_line(line, rules)

    case valid {
      True -> Ok(day05.find_middle_page(line))
      False -> Error(0)
    }
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(143)
}

pub fn day05_part2_sample_test() {
  let #(rules, lines) = #(
    [
      #(47, 53),
      #(97, 13),
      #(97, 61),
      #(97, 47),
      #(75, 29),
      #(61, 13),
      #(75, 53),
      #(29, 13),
      #(97, 29),
      #(53, 29),
      #(61, 53),
      #(97, 53),
      #(61, 29),
      #(47, 13),
      #(75, 47),
      #(97, 75),
      #(47, 61),
      #(75, 61),
      #(47, 29),
      #(75, 13),
      #(53, 13),
    ],
    [
      [75, 47, 61, 53, 29],
      [97, 61, 53, 29, 13],
      [75, 29, 13],
      [75, 97, 47, 61, 53],
      [61, 13, 29],
      [97, 13, 75, 29, 47],
    ],
  )

  lines
  |> list.filter_map(fn(line) {
    let filtered_rules = day05.filter_rules(rules, line)
    let valid = day05.evaluate_line(line, rules)

    case valid {
      True -> Error(0)
      False -> {
        Ok(
          line
          |> list.sort(fn(a, b) { day05.rule_compare(a, b, filtered_rules) })
          |> day05.find_middle_page,
        )
      }
    }
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(123)
}

pub fn day05_part1_input_test() {
  let #(rules, lines) = read_day05_input()

  lines
  |> list.filter_map(fn(line) {
    let valid = day05.evaluate_line(line, rules)

    case valid {
      True -> Ok(day05.find_middle_page(line))
      False -> Error(0)
    }
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(5208)
}

pub fn day05_part2_input_test() {
  let #(rules, lines) = read_day05_input()

  lines
  |> list.filter_map(fn(line) {
    let filtered_rules = day05.filter_rules(rules, line)
    let valid = day05.evaluate_line(line, rules)

    case valid {
      True -> Error(0)
      False -> {
        Ok(
          line
          |> list.sort(fn(a, b) { day05.rule_compare(a, b, filtered_rules) })
          |> day05.find_middle_page,
        )
      }
    }
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(6732)
}

pub fn day06_part1_sample_test() {
  day06.GuardMap(
    [
      day06.Obstacle(4, 0),
      day06.Obstacle(9, 1),
      day06.Obstacle(2, 3),
      day06.Obstacle(7, 4),
      day06.Obstacle(1, 6),
      day06.Obstacle(8, 7),
      day06.Obstacle(0, 8),
      day06.Obstacle(6, 9),
    ],
    day06.Guard(4, 6, day06.Up),
    dict.from_list([]),
    10,
    10,
  )
  |> day06.perform_guard_movement
  |> should.equal(41)
}

pub fn day06_part1_input_test() {
  read_day06_input()
  |> day06.perform_guard_movement
  |> should.equal(5199)
}

pub fn day07_part1_sample_test() {
  [
    #(190, [10, 19]),
    #(3267, [81, 40, 27]),
    #(83, [17, 5]),
    #(156, [15, 6]),
    #(7290, [6, 8, 6, 15]),
    #(161_011, [16, 10, 13]),
    #(192, [17, 8, 14]),
    #(21_037, [9, 7, 18, 13]),
    #(292, [11, 6, 16, 20]),
  ]
  |> list.map(day07.determine_correct_operation(_, False))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(3749)
}

pub fn day07_part1_input_test() {
  read_day07_input()
  |> list.map(day07.determine_correct_operation(_, False))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(2_664_460_013_123)
}

pub fn day07_part2_sample_test() {
  [
    #(190, [10, 19]),
    #(3267, [81, 40, 27]),
    #(83, [17, 5]),
    #(156, [15, 6]),
    #(7290, [6, 8, 6, 15]),
    #(161_011, [16, 10, 13]),
    #(192, [17, 8, 14]),
    #(21_037, [9, 7, 18, 13]),
    #(292, [11, 6, 16, 20]),
  ]
  |> list.map(day07.determine_correct_operation(_, True))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(11_387)
}

pub fn day07_part2_input_test() {
  read_day07_input()
  |> list.map(day07.determine_correct_operation(_, True))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> should.equal(426_214_131_924_213)
}
