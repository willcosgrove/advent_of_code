use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("input");
    let input = input.trim().to_string();

    println!("Solution 1: {}", fully_react(input.clone()).len());

    let units = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
    let answer_b = units.iter().map(|c| {
        let test_polymer = remove_unit(c, &input);
        fully_react(test_polymer).len()
    }).min().unwrap();

    println!("Solution 2: {}", answer_b);
}

fn index_of_reaction(polymer: &str) -> Option<usize> {
    let chars = polymer.chars();
    let next_chars = polymer.chars().skip(1);
    for (i, (char, next_char)) in chars.zip(next_chars).enumerate() {
        if char != next_char && char.eq_ignore_ascii_case(&next_char) {
            return Some(i as usize)
        }
    }
    return None
}

fn fully_react(mut polymer: String) -> String {
    while let Some(index_to_remove) = index_of_reaction(&polymer) {
        polymer.replace_range(index_to_remove..index_to_remove+2, "");
    }
    polymer
}

fn remove_unit(unit: &char, polymer: &str) -> String {
    let mut new_polymer : String = polymer.clone().into();
    new_polymer.retain(|c| !c.eq_ignore_ascii_case(unit));
    new_polymer
}
