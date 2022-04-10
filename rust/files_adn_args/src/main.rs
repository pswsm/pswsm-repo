extern crate argparse;
use argparse::{ArgumentParser, Store};
//use std::path::Path;


struct Options {
    output_file_name: String, 
    input_file_name: String,
}

fn main() {

    let mut options = Options {
        output_file_name: String::from(""),
        input_file_name: String::from(""),
    };

    /* Arguments scope */
    {
        let mut parser = ArgumentParser::new();

        parser.set_description("Testing arguments in rust.");
        parser.refer(&mut options.output_file_name)
            .add_argument("input-file", Store, "File to read");

        parser.refer(&mut options.input_file_name)
            .add_argument("ouptut-file", Store, "File to write");

        parser.parse_args_or_exit();
    }

    println!("Input file:{}\nOutput File:{}", options.input_file_name, options.output_file_name)
}
