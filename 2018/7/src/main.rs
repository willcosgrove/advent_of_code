extern crate regex;

use std::io::{self, Read};
use std::collections::{BTreeMap, HashSet};
use regex::Regex;

fn main() {
    let regex = Regex::new(r"Step (.) must be finished before step (.) can begin.").unwrap();
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("stdin");
    let input = input.trim();

    let mut dependencies: BTreeMap<char, HashSet<char>> = BTreeMap::new();

    for line in input.lines() {
        let captures = regex.captures(line).unwrap();
        let dependency = captures[1].chars().next().unwrap();
        let target = captures[2].chars().next().unwrap();

        dependencies.entry(dependency).or_insert_with(|| HashSet::new());
        let target_dependencies = dependencies.entry(target).or_insert_with(|| HashSet::new());
        target_dependencies.insert(dependency);
    }

    let mut order = String::new();
    let mut satisfied_targets: HashSet<char> = HashSet::new();

    while !dependencies.is_empty() {
        let first_satisfied_step;
        {
            let (step, _) = dependencies.iter().find(|(_step, deps)| deps.difference(&satisfied_targets).count() == 0).unwrap();
            first_satisfied_step = step.clone();
        }
        order.push(first_satisfied_step);
        satisfied_targets.insert(first_satisfied_step);
        dependencies.remove(&first_satisfied_step);
    }

    println!("Solution 1: {}", order);
}
