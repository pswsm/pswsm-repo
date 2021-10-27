"""Contains the code for drawing the sun and mercury"""
import turtle


def draw_sol(color: str = "#ffbf00", pos: tuple = (0, -50), size: int = 100):
    """Draws the sun"""
    turtle.color(color)
    turtle.penup()
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(size)
    turtle.end_fill()


def draw_mercuri(color: str = "#b2beb5", pos: tuple = (100, 150),
                 size: int = 10):
    """Draws planet mercury"""
    turtle.color(color)
    turtle.penup()
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(size)
    turtle.end_fill()
