# Un generador de contrasenyes funcional però "cutre". Fet en python.

from passlib.hash import pbkdf2_sha256
import string
import random

# pwd_context = CryptContext(
#     schemes=["pbkdf2_sha256"],
#     default="pbkdf2_sha256",
#     pbkdf2_sha256__default_rounds=30000
# )
#
# def passwd_encrypt(m):
#     return pwd_context.hash(m)

def passwd_gen():
    llargada = int(input("De quina llargada vols la contrasenya? "))
    abc = list(string.hexdigits)
    abc_psswd_list = random.sample(abc, llargada)
    final_passwd = ''.join(abc_psswd_list)
    print(f"Llista original: {abc}\nContrsenya generada: {final_passwd}")
    passwd_encriptat = pbkdf2_sha256.hash(final_passwd)
    f = open('passwd.txt', 'a+')
    f.write(f'{final_passwd}.{passwd_encriptat}\n')
    f.close()

passwd_gen()
