import gleam/dict
import gleam/erlang
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type GuardDirection {
  Up
  Down
  Left
  Right
}

pub type Guard {
  Guard(x: Int, y: Int, direction: GuardDirection)
}

pub type Obstacle {
  Obstacle(x: Int, y: Int)
}

pub type GuardMap {
  GuardMap(
    obstacles: List(Obstacle),
    guard: Guard,
    visited: dict.Dict(#(Int, Int), Bool),
    board_width: Int,
    board_height: Int,
  )
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

pub fn perform_guard_movement(map: GuardMap) -> Int {
  let updated_map = iterate_guard_movement(map)
  // |> print_board
  case updated_map {
    GuardMap(_, updated_guard, updated_visited, board_width, board_height) -> {
      case updated_guard {
        Guard(x, y, _) -> {
          case x < 0 || x >= board_width || y < 0 || y >= board_height {
            True -> {
              updated_visited |> dict.keys |> list.length
            }
            False -> {
              perform_guard_movement(updated_map)
            }
          }
        }
      }
    }
  }
}

fn iterate_guard_movement(map: GuardMap) -> GuardMap {
  let new_guard = case map {
    GuardMap(obstacles, guard, _, _, _) -> {
      case guard {
        Guard(guard_x, guard_y, guard_direction) -> {
          case
            obstacles
            |> list.any(fn(obstacle) {
              case obstacle {
                Obstacle(obstacle_x, obstacle_y) -> {
                  case guard_direction {
                    Up -> obstacle_x == guard_x && obstacle_y == guard_y - 1
                    Down -> obstacle_x == guard_x && obstacle_y == guard_y + 1
                    Left -> obstacle_x == guard_x - 1 && obstacle_y == guard_y
                    Right -> obstacle_x == guard_x + 1 && obstacle_y == guard_y
                  }
                }
              }
            })
          {
            True -> {
              case guard_direction {
                Up -> Guard(guard_x + 1, guard_y, Right)
                Down -> Guard(guard_x - 1, guard_y, Left)
                Left -> Guard(guard_x, guard_y - 1, Up)
                Right -> Guard(guard_x, guard_y + 1, Down)
              }
            }
            False -> {
              case guard_direction {
                Up -> Guard(guard_x, guard_y - 1, Up)
                Down -> Guard(guard_x, guard_y + 1, Down)
                Left -> Guard(guard_x - 1, guard_y, Left)
                Right -> Guard(guard_x + 1, guard_y, Right)
              }
            }
          }
        }
      }
    }
  }

  case map {
    GuardMap(obstacles, guard, visited, board_width, board_height) -> {
      GuardMap(
        obstacles,
        new_guard,
        case guard {
          Guard(x, y, _) -> {
            visited |> dict.insert(#(x, y), True)
          }
        },
        board_width,
        board_height,
      )
    }
  }
}

pub fn initialize_guard_map(board: List(String)) -> GuardMap {
  GuardMap(
    board
      |> list.index_map(fn(row, i) {
        row
        |> string.split("")
        |> list.index_map(fn(cell, j) {
          case cell {
            "#" -> Obstacle(j, i)
            _ -> Obstacle(-1, -1)
          }
        })
        |> list.filter(fn(coord) { coord != Obstacle(-1, -1) })
      })
      |> list.flatten,
    board
      |> list.index_fold(Guard(-1, -1, Up), fn(acc, row, i) {
        row
        |> string.split("")
        |> list.index_fold(acc, fn(acc2, cell, j) {
          case cell {
            "^" -> Guard(j, i, Up)
            "v" -> Guard(j, i, Down)
            "<" -> Guard(j, i, Left)
            ">" -> Guard(j, i, Right)
            _ -> acc2
          }
        })
      }),
    dict.new(),
    board |> list.length,
    board |> list.first |> result.unwrap("") |> string.length,
  )
}

fn print_board(guard_map: GuardMap) {
  io.println("-----------------")
  case guard_map {
    GuardMap(obstacles, guard, visited, board_width, board_height) -> {
      list.range(0, board_height)
      |> list.map(fn(row_index) {
        list.range(0, board_width)
        |> list.map(fn(cell_index) {
          case
            obstacles
            |> list.any(fn(obstacle) {
              obstacle.x == cell_index && obstacle.y == row_index
            })
          {
            True -> "#"
            False -> {
              case
                visited
                |> dict.to_list
                |> list.key_find(#(cell_index, row_index))
              {
                Ok(_) -> "X"
                Error(_) -> {
                  case guard {
                    Guard(x, y, direction) -> {
                      case x == cell_index && y == row_index {
                        True -> {
                          case direction {
                            Up -> "^"
                            Down -> "v"
                            Left -> "<"
                            Right -> ">"
                          }
                        }
                        False -> "."
                      }
                    }
                  }
                }
              }
            }
          }
        })
      })
      |> list.each(fn(row) { row |> string.join("") |> io.println })
      io.debug(visited)
    }
  }
  io.println("-----------------")
  guard_map
}

pub fn main() {
  read_lines([])
  |> initialize_guard_map
  // |> io.debug
  |> perform_guard_movement
  |> io.debug
}
