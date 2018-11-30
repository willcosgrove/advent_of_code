use std::io;
use std::io::Read;

fn main() {
    let mut captcha = String::from("");
    io::stdin().read_to_string(&mut captcha).expect("Failed to read line");
    let captcha: Vec<u32> = captcha.trim()
                                   .chars()
                                   .map(|letter| { letter.to_digit(10).unwrap() })
                                   .collect();

    let checksum: u32 = captcha.iter()
                               .enumerate()
                               .filter(|&(index, &number)| {
                                   number == captcha[(index + 1) % captcha.len()]
                               })
                               .map(|(_index, &number)| { number })
                               .sum();

    println!("{}", checksum);
}
