extern crate regex;

use std::io::{self, Read};
use std::collections::{HashSet, HashMap};
use regex::Regex;

struct Guard {
    id : i32,
    shifts : Vec<HashSet<i32>>,
}

impl Guard {
    fn new_shift(&mut self) -> () {
        let shift = HashSet::new();
        self.shifts.push(shift);
    }

    fn latest_shift(&mut self) -> &mut HashSet<i32> {
        let index = self.shifts.len() - 1;
        &mut self.shifts[index]
    }
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("input");
    let input = input.trim();
    let mut logs : Vec<&str> = input.lines().collect();
    logs.sort();
    let mut current_guard_id = 0;
    let mut guards_by_id : HashMap<i32, Guard> = HashMap::new();
    let shift_change_re = Regex::new(r"Guard #(\d+) begins shift").unwrap();
    let falls_asleep_re = Regex::new(r"00:(\d{2})] falls asleep").unwrap();
    let wakes_up_re = Regex::new(r"00:(\d{2})] wakes up").unwrap();
    let mut fall_asleep_time = 0;
    for log in logs.iter() {
        if let Some(capture) = shift_change_re.captures(log) {
            current_guard_id = capture[1].parse().unwrap();
            let guard = guards_by_id.entry(current_guard_id).or_insert(Guard { id: current_guard_id, shifts: vec![] });
            guard.new_shift();
        } else if let Some(capture) = falls_asleep_re.captures(log) {
            fall_asleep_time = capture[1].parse().unwrap();
        } else if let Some(capture) = wakes_up_re.captures(log) {
            let mut guard = guards_by_id.get_mut(&current_guard_id).unwrap();
            let shift = guard.latest_shift();
            for minute in fall_asleep_time..capture[1].parse().unwrap() {
                shift.insert(minute);
            }
        }
    }
    let sleepiest_guard : &Guard = guards_by_id.values().max_by_key(|guard| guard.shifts.iter().map(|shift| shift.len() as i32).sum::<i32>()).unwrap();
    println!("Sleepiest guard: {}", sleepiest_guard.id);

    let mut sleepiest_minutes : HashMap<i32, i32> = HashMap::with_capacity(60);
    for shift in sleepiest_guard.shifts.iter() {
        for minute in shift.iter() {
            let sleep_count = sleepiest_minutes.entry(*minute).or_insert(0);
            *sleep_count += 1;
        }
    }
    let (sleepiest_minute, _) = sleepiest_minutes.iter().max_by_key(|(_, sleep_count)| sleep_count.clone()).unwrap();
    println!("Sleepiest minute: {}", sleepiest_minute);
    println!("Solution 1: {}", sleepiest_guard.id * sleepiest_minute);

    let mut guard_sleep_minutes : HashMap<i32, HashMap<i32, i32>> = HashMap::new();
    for guard in guards_by_id.values() {
        let sleepiest_minutes = guard_sleep_minutes.entry(guard.id).or_insert_with(|| HashMap::new());
        for shift in guard.shifts.iter() {
            for minute in shift.iter() {
                let sleep_count = sleepiest_minutes.entry(*minute).or_insert(0);
                *sleep_count += 1;
            }
        }
    }
    println!("{:?}", guard_sleep_minutes);
    let (sleepiest_guard_id, _) = guard_sleep_minutes.iter().max_by_key(|(_, sleep_minutes)| sleep_minutes.values().max().unwrap_or(&0)).unwrap();
    println!("Sleepiest Guard: {}", sleepiest_guard_id);
    let (sleepiest_minute, _) = guard_sleep_minutes[sleepiest_guard_id].iter().max_by_key(|(_, sleep_count)| sleep_count.clone()).unwrap();
    println!("Solution 2: {}", sleepiest_guard_id * sleepiest_minute);
}
