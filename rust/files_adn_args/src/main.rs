use std::path::PathBuf;
use std::io::prelude::*;
use std::io::BufReader;
use std::fs::File;
use structopt::StructOpt;
use std::vec;
use rand::seq::SliceRandom;

#[derive(StructOpt)]
#[structopt(name = "CLI fasta toolkit",
            about = "A CLI toolkit to generate, edit and see fasta files",
            rename_all = "kebab-case")]
struct Args {
    #[structopt(subcommand)]
    cmdline: Command
}

#[derive(Debug, StructOpt)]
enum Command {
    Print(CatOptions),
    Cut(CutOptions),
    Generate(GenerateOptions)
}

#[derive(Debug, StructOpt)]
#[structopt(name = "print file options",
            about = "Reads file, prints its content",
            rename_all = "kebab-case")]
struct CatOptions {
    #[structopt(help = "The file to read")]
    file: PathBuf,
}

#[derive(Debug, StructOpt)]
#[structopt(name = "cutting options",
            about = "Cuts nucleotides from..to range",
            rename_all = "kebab-case")]
struct CutOptions {
    #[structopt(short, long = "output", help = "File to write", parse(from_os_str))]
    output_file_name: PathBuf,
    
    #[structopt(short, long = "input", help = "File to read")] 
    input_file_name: PathBuf,

    #[structopt(short, long, help = "Range(s) to cut")]
    range: String
}

#[derive(Debug, StructOpt)]
#[structopt(name = "generation options",
            about = "Generates a fasta file long n bases",
            rename_all = "kebab-case")]
struct GenerateOptions {

    #[structopt(help = "File to write to")]
    output_file: PathBuf,

    #[structopt(short = "n", long = "lines", help = "Number of lines to generate. Each line has 60 bases")] 
    length: u32,
}

fn main() {

    let args = Args::from_args();

    match args.cmdline {
        Command::Cut(args) => println!("{}", cutting(args.input_file_name, args.output_file_name, args.range).unwrap()),
        Command::Generate(args) => println!("{}", generate(args.length, args.output_file).unwrap()),
        Command::Print(args) => println!("{}", cat(args.file).unwrap_or(String::from("File not found. Check the if file exists."))),
    };
}

fn cutting(input_file_path: PathBuf, output_file_path: PathBuf, range: String) -> std::io::Result<String> {
    let text: String = input_file_path.into_os_string().into_string().expect("Can't read file. Maybe it does not exist?");
    let writing: String = output_file_path.into_os_string().into_string().unwrap_or(String::from("output.fasta"));
    let cutted_fasta: String = String::from("Cutted fasta");

    Ok(cutted_fasta)
}

fn cat(input_file: PathBuf) -> std::io::Result<String> {
    let file = File::open(input_file)?;
    let mut reader = BufReader::new(file);
    let mut contents: String = String::new();
    reader.read_to_string(&mut contents)?;
    Ok(contents)
}

fn generate(length: u32, file: PathBuf) -> std::io::Result<String> {
    let mut output_file = File::create(file).expect("Cannot create file");
    let atcg: Vec<String> = vec![String::from("a"), String::from("t"), String::from("c"), String::from("g")];
    let header: String = format!(">randomly generated sequence of {} bases\n", length);
    let mut sequence: String = String::new();

    output_file.write(header.as_bytes())?;
    output_file.write(b"\n")?;

    for _line in 1..=length {
        for _base in 1..=60 {
            sequence.push_str(&select_rnd_str(&atcg));
        }
        sequence.push_str("\n");
    }

    output_file.write(sequence.as_bytes())?;

    Ok(sequence)
}

fn select_rnd_str(string_list: &Vec<String>) -> String {
    let selected_string: String = String::from(string_list.choose(&mut rand::thread_rng()).unwrap());
    selected_string
}
