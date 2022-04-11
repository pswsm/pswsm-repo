use std::path::PathBuf;
use std::io::prelude::*;
use std::io::BufReader;
use std::fs::File;
use structopt::StructOpt;
//use std::vec;

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
    #[structopt(short, long = "input", help = "The file to read")]
    input_file_name: PathBuf,
}

#[derive(Debug, StructOpt)]
#[structopt(name = "cutting options",
            about = "Cuts nucleotides from..to range",
            rename_all = "kebab-case")]
struct CutOptions {
    #[structopt(short, long = "output", help = "File to write", parse(from_os_str))]
    output_file_name: PathBuf,
    
    #[structopt(short, long = "input", help = "File to read", parse(from_os_str))]
    input_file_name: PathBuf,

    #[structopt(short, long, help = "Range(s) to cut")]
    range: String
}

#[derive(Debug, StructOpt)]
#[structopt(name = "generation options",
            about = "Generates a fasta file long n nucleotides",
            rename_all = "kebab-case")]
struct GenerateOptions {
    #[structopt(short = "n", long, help = "Number of bases")] 
    length: u32,
}

fn main() {
    let args = Args::from_args();

    match args.cmdline {
        Command::Cut(args) => cutting(args.input_file_name, args.output_file_name, args.range).unwrap(),
        Command::Generate(args) => generate(args.length).unwrap(),
        Command::Print(args) => cat(args.input_file_name).unwrap(),
    };
}

fn cutting(input_file_path: PathBuf, output_file_path: PathBuf, range: String) -> std::io::Result<()> {
    println!("Reading {}\nWriting {} with range {}", input_file_path.into_os_string().into_string().unwrap(), output_file_path.into_os_string().into_string().unwrap(), range);
    Ok(())
}

fn cat(input_file: PathBuf) -> std::io::Result<()> {
    let file = File::open(input_file)?;
    let mut reader = BufReader::new(file);
    let mut contents: String = String::new();
    reader.read_to_string(&mut contents)?;
    println!("{}", contents);
    Ok(())
}

fn generate(length: u32) -> std::io::Result<()> {
    println!("Length to generate is: {}", length);
    Ok(())
}
