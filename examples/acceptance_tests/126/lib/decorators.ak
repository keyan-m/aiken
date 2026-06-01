@list
type Dino {
  food: Int,
  weight: Int,
  name: ByteArray,
}

type Wow {
  @tag(2)
  Het { first: Dino, second: (Int, ByteArray) }
  Toro(Int)
}

type Wowzer {
  first: Dino,
  second: (Int, ByteArray),
}

@tag(2)
type CanWork {
  first: Dino,
  second: (Int, ByteArray),
}

@int
type Signal {
  Red
  @tag(7)
  Yellow
  Green
}

fn yes(
  food: Int,
  weight: Int,
  name: ByteArray,
  combiner: fn(Int, Int, ByteArray) -> a,
) -> a {
  combiner(food, weight, name)
}

test foo() {
  let x = Dino(1, 2, "t-rex")
  let gg = yes(1, 4, "triceratops", Dino)

  let y: Data = x

  expect (a, b, c): (Int, Int, ByteArray) = y
  expect z: Dino = y
  expect Dino { food, weight, name } as ff = y

  let xx = Dino { ..z, name: "stegosaurus", food: 9 }

  let n = Dino { food: x.food, weight: x.weight, name: x.name }

  let yy = x |> as_data

  let Dino { food: food1, weight: weight1, .. } = ff

  and {
    x.food == 1,
    a == 1,
    b == 2,
    c == "t-rex",
    x == z,
    food == 1,
    weight == 2,
    xx.food == 9,
    xx.name == "stegosaurus",
    xx.weight == z.weight,
    yy == y,
    gg.food == x.food,
    gg.weight == 4,
    gg.name == "triceratops",
    gg != x,
    n == x,
    ff.weight == 2,
    food1 == x.food,
  }
}

test bar() {
  let x = Dino(1, 2, "t-rex")
  let y = Het(x, (4, "no"))
  let z = CanWork(x, (4, "no")) |> as_data

  expect Het { first: Dino(1, b, "t-rex"), second: (4, "no") } = y |> as_data

  expect Het { first: Dino(1, c, "t-rex"), second: (4, "no") } = y

  when y is {
    Toro(1) -> False
    Toro(2) -> False
    Toro(_) -> fail @"No way"
    Het { first: Dino(1, 1, "t-rex"), second: (4, "no") } -> False
    Het { first: Dino(1, 2, "t-rex"), second: (5, "no") } -> False
    Het { first: Dino(1, 2, "t-rex"), second } -> {
      trace @"Z": z
      expect d: Wow = z

      and {
        b == 2,
        c == 2,
        second == (4, "no"),
        d == y,
      }
    }
    Het { .. } -> fail @"Impossible"
  }
}

test int_decorator() {
  let red: Data = Red
  let yellow: Data = Yellow
  let green = Green |> as_data
  let red_data_from_int: Data = 0
  let yellow_data_from_int: Data = 7
  let green_data_from_int: Data = 2

  expect red_index: Int = red
  expect yellow_index: Int = yellow
  expect green_index: Int = green
  expect yellow_signal: Signal = yellow_data_from_int
  expect Red: Signal = red_data_from_int
  expect Yellow: Signal = yellow_data_from_int
  expect Green: Signal = green_data_from_int

  let red_does_not_match_yellow = if yellow_data_from_int is Red: Signal {
    False
  } else {
    True
  }

  let yellow_signal_is_yellow = when yellow_signal is {
    Yellow -> True
    _ -> False
  }

  and {
    red_index == 0,
    yellow_index == 7,
    green_index == 2,
    yellow_signal == Yellow,
    red_does_not_match_yellow,
    yellow_signal_is_yellow,
  }
}

test baz() fail {
  let x = Dino(1, 2, "t-rex")
  let y = Wowzer(x, (4, "no"))

  let d = as_data(y)

  expect Het { .. } = d
}
