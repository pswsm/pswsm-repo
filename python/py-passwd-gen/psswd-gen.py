# Un generador de contrasenyes funcional.

from pathlib import Path
from passlib.hash import pbkdf2_sha256
import string, random, argparse
import random


def mk_args():
    """Parses arguments if given, uses the defaults when not."""
    parser = argparse.ArgumentParser(description="Password generator. Stores its sha256 hash in a file")
    parser.add_argument('-l', '--length', help='Length of the password', type=int, required=True)
    parser.add_argument('-f', '--file', help='File to save the passwords. Defaults to passwords.txt', default='passwords.txt')
    parsed_args = parser.parse_args()
    return parsed_args.length, parsed_args.file

def passwd_gen(length) -> tuple[str, str]:
    abc: list[str] = list(string.printable)
    abc_psswd_list: list[str] = random.sample(abc, length)
    final_passwd: str = ''.join(abc_psswd_list)
    passwd_encriptat: str = pbkdf2_sha256.hash(final_passwd)
    return final_passwd, passwd_encriptat

def main(length, file):
    password, crypt_password = passwd_gen(length)
    print(password)
    try:
        open_file = Path(file).open(mode='x', encoding='UTF-8')
    except:
        open_file = Path(file).open(mode='a', encoding='UTF-8')
    finally:
        open_file.write(crypt_password+'\n')
        open_file.close()

if __name__ == '__main__':
    length, file = mk_args()
    main(length, file)
