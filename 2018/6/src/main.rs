use std::io::{self, Read};
use std::collections::{HashMap, HashSet};
use std::collections::hash_map::Entry;
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
    id : i32,
    origin : Point,
    area : HashSet<Point>,
}
impl Location {
    fn distance(&self, to : Point) -> i32 {
        let Point(dis_x, dis_y) = self.origin - to;
        dis_x.abs() + dis_y.abs()
    }
}

enum Area<'a> {
    Claimed(&'a Location),
    Contention,
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("stdin");
    let input = input.trim();
    let mut location_id = 0;
    let locations : Vec<Location> = input.lines().map(|line| {
        let coordinate_strings : Vec<&str> = line.split(", ").collect();
        let x : i32 = coordinate_strings[0].parse().unwrap();
        let y : i32 = coordinate_strings[1].parse().unwrap();
        location_id += 1;
        Location { id: location_id, origin: Point(x, y), area: HashSet::new() }
    }).collect();

    let mut world : HashMap<Point, Area> = HashMap::new();
    let min_x = locations.iter().map(|location| location.origin.0).min().unwrap();
    let min_y = locations.iter().map(|location| location.origin.1).min().unwrap();
    let max_x = locations.iter().map(|location| location.origin.0).max().unwrap();
    let max_y = locations.iter().map(|location| location.origin.1).max().unwrap();

    println!("Min ({}, {}), Max ({}, {})", min_x, min_y, max_x, max_y);

    for location in locations.iter() {
        world.insert(location.origin, Area::Claimed(&location));
    }

    let mut maximally_expanded_locations : HashSet<i32> = HashSet::new();
    let mut distance = 1;

    while maximally_expanded_locations.len() != locations.len() {
        for location in locations.iter() {
            let mut claimed_areas = 0;
            for point in location.origin.circumference_points(distance).iter() {
                if point.0 < min_x || point.0 > max_x || point.1 < min_y || point.1 > max_x {
                    maximally_expanded_locations.insert(location.id);
                    break;
                }
                match world.entry(*point) {
                    Entry::Vacant(mut entry) => { entry.insert(Area::Claimed(&location)); },
                    Entry::Occupied(mut entry) => {
                        let mut area = entry.get_mut();
                        match area {
                            Area::Claimed(other_location) => {
                                if location.distance(*point) == other_location.distance(*point) {
                                    *area = Area::Contention;
                                    claimed_areas += 1;
                                }
                            },
                            _ => ()
                        }
                    }
                }
            }
            if claimed_areas == 0 {
                maximally_expanded_locations.insert(location.id);
            }
        }
        distance += 1;
    }
}
