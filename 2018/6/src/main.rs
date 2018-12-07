use std::io::{self, Read};
use std::collections::{HashMap, HashSet};
use std::ops::{Add, Sub, Mul};

#[derive(Copy, Clone, Eq, Hash)]
struct Point(i32, i32);

impl Mul for Point {
    type Output = Self;

    fn mul(self, rhs : Self) -> Self {
        let Point(x1, y1) = self;
        let Point(x2, y2) = rhs;

        Point(x1 * x2, y1 * y2)
    }
}
impl Add for Point {
    type Output = Self;

    fn add(self, rhs : Self) -> Self {
        let Point(x1, y1) = self;
        let Point(x2, y2) = rhs;

        Point(x1 + x2, y1 + y2)
    }
}
impl Sub for Point {
    type Output = Self;

    fn sub(self, rhs : Self) -> Self {
        let Point(x1, y1) = self;
        let Point(x2, y2) = rhs;

        Point(x1 - x2, y1 - y2)
    }
}
impl PartialEq for Point {
    fn eq(&self, other : &Self) -> bool {
        self.0 == other.0 && self.1 == other.1
    }
}
impl Point {
    fn circumference_points(self, radius : i32) -> Vec<Point> {
        let reflections = [Point(1, 1), Point(1, -1), Point(-1, 1), Point(-1, -1)];
        (0..=radius)
            .zip((0..=radius).rev())
            .flat_map::<Vec<Point>, _>(|(x, y)| {
                reflections.iter().map(|reflection| *reflection * Point(x, y)).collect()
            })
            .map(|edge_point| self + edge_point)
            .collect()
    }
}

struct Location {
    origin : Point,
    area : HashSet<Point>,
}
impl Location {
    fn distance(&self, to : Point) -> i32 {
        let Point(dis_x, dis_y) = self.origin - to;
        dis_x.abs() + dis_y.abs()
    }
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("stdin");
    let input = input.trim();
    let locations : Vec<Location> = input.lines().map(|line| {
        let coordinate_strings : Vec<&str> = line.split(", ").collect();
        let x : i32 = coordinate_strings[0].parse().unwrap();
        let y : i32 = coordinate_strings[1].parse().unwrap();
        Location { origin: Point(x, y), area: HashSet::new() }
    }).collect();
    let mut world : HashMap<Point, &Location> = HashMap::new();
}
