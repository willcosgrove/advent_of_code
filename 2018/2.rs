use std::io::{self, Read};
use std::collections::HashMap;

fn main() {
  let mut input = String::new();
  io::stdin().read_to_string(&mut input).expect("stdin");
  input = input.trim().to_string();

  let mut ids_with_two_same_characters = 0;
  let mut ids_with_three_same_characters = 0;

  for line in input.lines() {
    let mut letter_counts = HashMap::new();
    for char in line.chars() {
      let char_count = letter_counts.entry(char).or_insert(0);
      *char_count += 1;
    }

    for (_, &count) in &letter_counts {
      if count == 2 {
        ids_with_two_same_characters += 1;
        break;
      }
    }

    for (_, &count) in &letter_counts {
      if count == 3 {
        ids_with_three_same_characters += 1;
        break;
      }
    }
  }

  println!("Part 1 Solution: {}", ids_with_two_same_characters * ids_with_three_same_characters);

  let mut ids : Option<(&str, &str)> = None;

  for (current_index, line) in input.lines().enumerate() {
    for (comparison_index, cmp_line) in input.lines().enumerate() {
      if current_index == comparison_index { continue }
      let mut distance = 0;
      for (char1, char2) in line.chars().zip(cmp_line.chars()) {
        if char1 != char2 {
          distance += 1;
          if distance > 1 { break }
        }
      }
      if distance == 1 {
        ids = Some((line, cmp_line));
        break;
      }
    }
  };

  match ids {
    Some((id1, id2)) => { println!("Matching ids: {} and {}", id1, id2) },
    None => { println!("We found no close IDs") },
  }
}
