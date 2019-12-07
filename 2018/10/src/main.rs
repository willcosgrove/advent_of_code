extern crate regex;
use std::io::{self, Read};
use regex::Regex;

#[derive(Clone)]
struct Particle {
    position: (i32, i32),
    velocity: (i32, i32),
}

impl Particle {
    fn tick(&mut self) -> () {
        self.tick_by(1);
    }

    fn tick_by(&mut self, step: i32) -> () {
        self.position = (
            self.position.0 + (self.velocity.0 * step),
            self.position.1 + (self.velocity.1 * step),
        );
    }
}

struct ParticleBoundingBox {
    top_left: (i32, i32),
    width: i32,
    height: i32,
}

impl ParticleBoundingBox {
    fn normalize(&self, coordinate: (i32, i32)) -> (i32, i32) {
        (coordinate.0 - self.top_left.0, coordinate.1 - self.top_left.1)
    }

    // fn pad(&self, padding: i32) -> ParticleBoundingBox {
    //     ParticleBoundingBox {
    //         top_left: (self.top_left.0 - padding, self.top_left.1 - padding),
    //         width: self.width + (padding * 2),
    //         height: self.height + (padding * 2),
    //     }
    // }
}

fn main() {
    let regex = Regex::new(r"position=<(.+)> velocity=<(.+)>").unwrap();
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("stdin");
    let input = input.trim();
    let mut particles: Vec<Particle> = input.lines().map(|line| {
        let captures = regex.captures(line).unwrap();
        let position: Vec<&str> = captures[1].split(", ").collect();
        let velocity: Vec<&str> = captures[2].split(", ").collect();
        Particle {
            position: (position[0].trim().parse().unwrap(), position[1].trim().parse().unwrap()),
            velocity: (velocity[0].trim().parse().unwrap(), velocity[1].trim().parse().unwrap()),
        }
    }).collect();

    let mut bbox : ParticleBoundingBox;
    let mut previous_bbox : ParticleBoundingBox = ParticleBoundingBox { top_left: (0,0), width: i32::max_value(), height: i32::max_value() };
    let mut i = 0;
    loop {
        i += 1;
        for mut particle in particles.iter_mut() {
            particle.tick();
        };
        bbox = bounding_box(&particles);
        if bbox.width > previous_bbox.width && bbox.height > previous_bbox.height {
            for mut particle in particles.iter_mut() {
                particle.tick_by(-1);
            };
            println!("Solution 1:");
            draw(&previous_bbox, &particles);
            println!("Solution 2: {}", i - 1);
            break
        }
        previous_bbox = bbox;
    }
}

fn draw(bbox: &ParticleBoundingBox, particles: &Vec<Particle>) -> () {
    let mut board = vec![' '; (bbox.width * bbox.height) as usize];
    for particle in particles {
        let normalized_position = bbox.normalize(particle.position);
        board[(normalized_position.0 + (normalized_position.1 * bbox.width)) as usize] = '#';
    };

    for (i, pixel) in board.iter().enumerate() {
        if i != 0 && i % bbox.width as usize == 0 { print!("{}", '\n') };
        print!("{}", pixel);
    };

    println!();
}

fn bounding_box(particles: &Vec<Particle>) -> ParticleBoundingBox {
    let mut min_x = i32::max_value();
    let mut max_x = i32::min_value();
    let mut min_y = i32::max_value();
    let mut max_y = i32::min_value();

    for particle in particles {
        if particle.position.0 > max_x {
            max_x = particle.position.0;
        }
        if particle.position.0 < min_x {
            min_x = particle.position.0;
        }
        if particle.position.1 > max_y {
            max_y = particle.position.1;
        }
        if particle.position.1 < min_y {
            min_y = particle.position.1;
        }
    }

    ParticleBoundingBox {
        top_left: (min_x, min_y),
        width: max_x - min_x + 1,
        height: max_y - min_y + 1,
    }
}
