// use std::io;
use std::collections::HashMap;

type Signal = u16;

struct Circuit {
    wires: HashMap<String, Wire>,
    wireables: Vec<Wireable>,
}

impl Circuit {
    fn new() -> Circuit {
        Circuit {
            wires: HashMap::new(),
            wireables: vec![],
        }
    }

    fn add_signal_wire(&mut self, id: String, signal: Signal) {
        let new_signal = Wireable::Signal(signal);
        let wireable_index = self.wireables.len();
        self.wireables.push(new_signal);
        self.wires.insert(id, Wire(wireable_index));
    }

    fn add_and_gate(&mut self, id: String, inputs: (String, String)) {
        let new_and_gate = Wireable::AndGate(inputs.0, inputs.1);
        let wireable_index = self.wireables.len();
        self.wireables.push(new_and_gate);
        self.wires.insert(id, Wire(wireable_index));
    }

    fn add_or_gate(&mut self, id: String, inputs: (String, String)) {
        let new_or_gate = Wireable::OrGate(inputs.0, inputs.1);
        let wireable_index = self.wireables.len();
        self.wireables.push(new_or_gate);
        self.wires.insert(id, Wire(wireable_index));
    }

    fn add_lshift_gate(&mut self, id: String, input: String, shift: u16) {
        let new_lshift_gate = Wireable::LShiftGate{ input: input, shift: shift };
        let wireable_index = self.wireables.len();
        self.wireables.push(new_lshift_gate);
        self.wires.insert(id, Wire(wireable_index));
    }

    fn add_rshift_gate(&mut self, id: String, input: String, shift: u16) {
        let new_rshift_gate = Wireable::RShiftGate{ input: input, shift: shift };
        let wireable_index = self.wireables.len();
        self.wireables.push(new_rshift_gate);
        self.wires.insert(id, Wire(wireable_index));
    }

    fn add_not_gate(&mut self, id: String, input: String) {
        let new_not_gate = Wireable::NotGate(input);
        let wireable_index = self.wireables.len();
        self.wireables.push(new_not_gate);
        self.wires.insert(id, Wire(wireable_index));
    }

    fn output_on_wire(&self, wire_id: String) -> Signal {
        let Wire(wire_input_index) = self.wires[&wire_id];
        let ref wire_input = self.wireables[wire_input_index];
        return self.output_for_wireable(wire_input).clone();
    }

    fn output_on_wire_with_ref(&self, wire_id: &String) -> Signal {
        let Wire(wire_input_index) = self.wires[wire_id];
        let ref wire_input = self.wireables[wire_input_index];
        return self.output_for_wireable(wire_input).clone();
    }

    fn output_for_wireable(&self, wireable: &Wireable) -> Signal {
        match wireable {
            &Wireable::Signal(signal) => return signal,
            &Wireable::AndGate(ref input_1_key, ref input_2_key) => return self.output_on_wire_with_ref(input_1_key) & self.output_on_wire_with_ref(input_2_key),
            &Wireable::OrGate(ref input_1_key, ref input_2_key) => return self.output_on_wire_with_ref(input_1_key) | self.output_on_wire_with_ref(input_2_key),
            &Wireable::LShiftGate{ input: ref input_key, shift} => return self.output_on_wire_with_ref(input_key) << shift,
            &Wireable::RShiftGate{ input: ref input_key, shift} => return self.output_on_wire_with_ref(input_key) >> shift,
            &Wireable::NotGate(ref input_key) => return !self.output_on_wire_with_ref(input_key),
        }
    }
}

enum Wireable {
    Signal(Signal),
    AndGate (String, String),
    OrGate (String, String),
    LShiftGate { input: String, shift: u16 },
    RShiftGate { input: String, shift: u16 },
    NotGate(String),
}

struct Wire (usize);

fn main() {
    let mut circuit = Circuit::new();
    circuit.add_signal_wire("x".to_string(), 123);
    circuit.add_signal_wire("y".to_string(), 456);
    circuit.add_and_gate("d".to_string(), ("x".to_string(), "y".to_string()));
    circuit.add_or_gate("e".to_string(), ("x".to_string(), "y".to_string()));
    circuit.add_lshift_gate("f".to_string(), "x".to_string(), 2);
    circuit.add_rshift_gate("g".to_string(), "y".to_string(), 2);
    circuit.add_not_gate("h".to_string(), "x".to_string());
    circuit.add_not_gate("i".to_string(), "y".to_string());
    println!("d: {}", circuit.output_on_wire("d".to_string()));
    println!("e: {}", circuit.output_on_wire("e".to_string()));
    println!("f: {}", circuit.output_on_wire("f".to_string()));
    println!("g: {}", circuit.output_on_wire("g".to_string()));
    println!("h: {}", circuit.output_on_wire("h".to_string()));
    println!("i: {}", circuit.output_on_wire("i".to_string()));
    println!("x: {}", circuit.output_on_wire("x".to_string()));
    println!("y: {}", circuit.output_on_wire("y".to_string()));
}
