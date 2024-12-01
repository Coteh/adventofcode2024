import gleam/int
import gleam/list
import gleam/string
import simplifile
import gleeunit
import gleeunit/should
import day01

pub fn main() {
    gleeunit.main()
}

fn read_day01_input() -> List(List(Int)) {
    case simplifile.read("input/day01/input") {
        Ok(file) -> string.trim(file) |> string.split("\n") 
            |> list.map(fn (str_val) { string.split(str_val, "   ") 
            |> list.map(fn (x) { 
                case int.parse(x) {
                    Ok(val) -> val
                    Error(_) -> 0
                }
            })
        })
        Error(_) -> []
    }
}

pub fn day01_distance_test() {
    day01.calculate_total_distance([
        [3,4],
        [4,3],
        [2,5],
        [1,3],
        [3,9],
        [3,3],
    ]) |> should.equal(11)

    day01.calculate_total_distance([
        [3,4],
        [10,9],
    ]) |> should.equal(2)

    day01.calculate_total_distance(read_day01_input())
        |> should.equal(2192892)
}

pub fn day01_similarity_test() {
    day01.calculate_similarity_score([
        [3,4],
        [4,3],
        [2,5],
        [1,3],
        [3,9],
        [3,3],
    ]) |> should.equal(31)

    day01.calculate_similarity_score([
        [3,4],
        [10,9],
    ]) |> should.equal(0)

    day01.calculate_similarity_score(read_day01_input())
        |> should.equal(22962826)
}