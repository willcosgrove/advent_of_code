extern crate regex;
use std::io::{self, Read};
use std::collections::{HashMap, HashSet};
use std::thread::{sleep_ms};
use regex::Regex;

struct Claim {
  id: i32,
  x : i32,
  y : i32,
  width : i32,
  height : i32,
}

impl Claim {
  fn points(&self) -> Vec<(i32, i32)> {
    let mut points = Vec::with_capacity((self.width * self.height) as usize);
    for x in self.x..(self.x + self.width) {
      for y in self.y..(self.y + self.height) {
        points.push((x, y));
      }
    }
    points
  }
}

fn main() {
  let mut input = String::new();
  io::stdin().read_to_string(&mut input).expect("stdin");

  let claim_regex = Regex::new(r"(?P<id>\d+) @ (?P<x>\d+),(?P<y>\d+): (?P<width>\d+)x(?P<height>\d+)").unwrap();
  let claims : Vec<Claim> = claim_regex.captures_iter(&input).map(|claim_data| {
    Claim {
      id: claim_data["id"].parse().unwrap(),
      x: claim_data["x"].parse().unwrap(),
      y: claim_data["y"].parse().unwrap(),
      width: claim_data["width"].parse().unwrap(),
      height: claim_data["height"].parse().unwrap(),
    }
  }).collect();

  println!("Loaded claims");
  sleep_ms(5000);

  let mut fabric : HashMap<i32, HashSet<i32>> = HashMap::with_capacity(1000 * 1000);

  println!("Initialized fabric");
  sleep_ms(5000);

  for claim in claims.iter() {
    for (x, y) in claim.points().iter() {
      let location = fabric.entry((*x * 1000) + *y).or_insert_with(|| HashSet::new());
      location.insert(claim.id);
    }
  }

  println!("Inserted claims into fabric");
  sleep_ms(5000);

  let sqin_double_counted_fabric = fabric.values().filter(|&set| set.len() > 1).count();

  println!("Solution 1: {}", sqin_double_counted_fabric);

  for claim in claims.iter() {
    if fabric.values().filter(|&set| set.contains(&claim.id)).all(|set| set.len() == 1) {
      println!("Solution 2: {}", claim.id);
      break;
    }
  }

  sleep_ms(5000);
}
