use std::io::{self, Read};

struct NodeHeader<'a> {
    childrenCount: i32,
    metadataCount: i32,
    node: &'a Node<'a>,
}

struct Node<'a> {
    children: Vec<&'a Node<'a>>,
    metadata: Vec<i32>,
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("stdin");
    let input = input.trim();
    let entries = input.split(" ").map(|node| node.parse::<i32>().unwrap());
    let rootNode = Node { children: Vec::new(), metadata: Vec::new() };
    let mut stack: Vec<NodeHeader> = Vec::new();
    let mut nodes: Vec<Node> = Vec::new();
    stack.push(NodeHeader { childrenCount: 1, metadataCount: 0, node: &rootNode });
    nodes.push(rootNode);

    for entry in entries {

    }
}
