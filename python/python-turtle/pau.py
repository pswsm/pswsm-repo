# Sol + 3 planetes

import turtle


def sol():
    turtle.pendown()
    turtle.colormode(255)
    turtle.color(204, 136, 0)
    turtle.begin_fill()
    turtle.circle(500, 180)
    turtle.end_fill()
    turtle.penup()


def mercuri():
    turtle.pendown()
    turtle.color(75, 75, 75)
    turtle.begin_fill()
    turtle.circle(50)
    turtle.end_fill()
