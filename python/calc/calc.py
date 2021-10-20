# Made by pswsm in 1/10/2021 #
import os


def suma(a, b):
    try:
        a + b
    except:
        pass
    else:
        r = a + b
        print(r)


def resta(a, b):
    try:
        a - b
    except:
        pass
    else:
        r = a - b
        print(r)


def multi(a, b):
    try:
        a * b
    except:
        pass
    else:
        r = a * b
        print(r)


def divi(a, b):
    try:
        a / b
    except:
        pass
    else:
        r = a / b
        print(r)


while 1:
    op = input("Introdueixi operació:\n").split(" ")
    for i in range(len(op)):
        # print(f"{type(op[i])}\t{op[i]}\n")
        try:
            float(op[i])
        except ValueError:
            pass
        else:
            op[i] = float(op[i])
        # print(f"{type(op[i])}\t{op[i]}\n")

    if "+" in op:
        suma(op[0], op[2])
    elif "-" in op:
        resta(op[0], op[2])
    elif "*" in op:
        multi(op[0], op[2])
    elif "/" in op:
        divi(op[0], op[2])

    qC = input("Vols fer una altra operació?[y/n]\n")
    if qC == "n" or qC == "N":
        exit(0)
    else:
        os.system("clear")
        continue
