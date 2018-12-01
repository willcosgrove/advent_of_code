use std::io::{self, Read};

fn main() {
  let mut input = String::new();
  io::stdin().read_to_string(&mut input).expect("Stdin");
  let input = input.trim();

  // Part 1
  let sum : i32 = input.lines().map(|line| line.parse::<i32>().expect("Line to be a number") ).sum();
  println!("Part 1 Solution: {}", sum);

  // Part 2
  let mut seen_frequencies : Vec<i32> = vec![];
  let mut first_double_frequency : Option<i32> = None;
  let mut sum = 0;
  for frequency in input.lines().map(|line| line.parse::<i32>().expect("Line to be a number") ).cycle() {
    let new_sum = sum + frequency;
    if seen_frequencies.contains(&new_sum) {
      if let Some(_double) = first_double_frequency {
      } else {
        first_double_frequency = Some(new_sum);
        break;
      }
    }
    seen_frequencies.push(new_sum);
    sum = new_sum;
  }

  if let Some(double) = first_double_frequency {
    println!("Part 2 Solution: {}", double);
  }
}
