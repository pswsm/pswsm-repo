#!/usr/bin/env python
#-- encoding: UTF-8

#made by pswsm

import turtle


def square(x: float = 0, y: float = 0, length: float = 100):
    '''Draws a square and returns the vertice coordinates'''
    turtle.setup(width = 500, height = 500)
    turtle.penup()
    turtle.goto(turtle.xcor()-(length/2), turtle.ycor()-(length/2))
    turtle.pendown()
    for i in range(4):
        turtle.forward(length)
        print(f"Vertice {i} is on {turtle.pos()}")
        turtle.left(90)
    turtle.penup()
    turtle.home()
    return 0


square()
turtle.done()
