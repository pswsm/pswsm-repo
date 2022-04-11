use std::path::{Path, PathBuf};
use std::io::prelude::*;
use std::fs::File;
use structopt::StructOpt;
use std::convert::AsRef;
use strum_macros::AsRefStr;
//use std::vec;

#[derive(AsRefStr)]
enum Options {
    print,
    cut,
    generate
}

#[derive(Debug, StructOpt)]
#[structopt(name = "argument handling", about = "Reads a file, does something with its contents, writes to another file. All this theoretically.", rename_all = "kebab-case")]
struct Args {
    #[structopt(short, long = "input", help = "File to read", parse(from_os_str))]
    input_file_name: PathBuf,
    
    #[structopt(short, long = "output", help = "File to write", parse(from_os_str))]
    output_file_name: PathBuf,

    main_op: String,

}

fn main() {
    let args = Args::from_args();

    let print: Options = Options::print;
    let cut: Options = Options::cut;
    let generate: Options = Options::generate;

    let print_as_ref = print.as_ref();
    let cut_as_ref = cut.as_ref();
    let generate = generate.as_ref();

    match args.main_op {
        print_as_ref => print_file(args.input_file_name),
        //cut_as_ref => cut(),
        //generate_as_ref => generate(,)
        _ => println!("{} is not an option. See [-h --help] for more info.", args.main_op)
    }

}

fn print_file(file: PathBuf) {

    let mut open_file = File::open(file).expect("Can't open desired file.");
    let mut file_data: String = String::new();

    open_file.read_to_string(&mut file_data).expect("Can't read file.");

    println!("{}", file_data);


}
