from turtle import *
from os import *
from random import *

leftRight = ["left", "right"]
dirShape = ["direction", "shape"]

def goCenter():
    penup()
    goto(0, 0)
    pendown()

def goStart():
    penup()
    goto(-50, -50)
    pendown()

def triangle():
    clear()
    setup(500, 500, 0, 0)
    title("Triangle")
    goStart()
    for i in range(3):
        forward(100)
        left(120)

def quadrat():
    clear()
    setup(500, 500, 0, 0)
    title("Quadrat")
    goStart()
    circle(50, None, 4)

def pentagon():
    clear()
    setup(500, 500, 0, 0)
    title("Pentagon")
    circle(50, None, 5)

def octagon():
    clear()
    setup(500, 500, 0, 0)
    title("Octagon")
    circle(50, 360, 8)

def randomLines():
    traces = randint(3, 250)
    print(f"Es faran {str(traces)} traces")
    clear()
    setup(1250, 750, 0, 0)
    title("Linies aleatories")
    colormode(255)
    speed(0)
    for i in range(traces):
        # print(f"Queden {str(traces - i)}")
        if (xcor() > 501 or xcor() < -501) or (ycor() > 501 or ycor() < -501):
            goto(randint(-1249, 1249), randint(-749, 749))
        pencolor(randint(0, 255),randint(0, 255),randint(0, 255))
        chDirShape = choice(dirShape)
        if chDirShape == "direction":
            forward(randint(0, 1000))
            chosenDirection = choice(leftRight)
            if chosenDirection == left:
                left(randint(1, 360))
            else:
                right(randint(1, 360))
        else:
            circle(randint(5, 500), randint(10, 360), randint(3, 10000))


figures = ["Triangle", "Quadrat", "Pentagon", "Octagon", "Random", "Random entre opcions"]

while 1:
    for i, value in enumerate(figures):
        print(f"{i+1}. {figures[i]}")
    figura = input("Quina figura vols fer?\n").lower()
    system('clear')
    if "triangle" in figura or figura == '1':
        triangle()
    elif "quadrat" in figura or figura == '2':
        quadrat()
    elif "pentagon" in figura or figura == '3':
        pentagon()
    elif "octagon" in figura or figura == '4':
        octagon()
    elif "random" in figura or figura == '5':
        randomLines()
    elif "random enter opcions" in figura or figura == '6':
        randomFigura = randint(0, 4)
        if randomFigura == 0:
            triangle()
        elif randomFigura == 1:
            quadrat()
        elif randomFigura == 2:
            pentagon()
        elif randomFigura == 3:
            octagon()
        elif randomFigura == 4:
            randomLines()


    qc = input("\nVols continuar? [S/n]")
    if qc == 'n' or qc == 'N':
        exit(0)
    else:
        continue
    system('clear')
