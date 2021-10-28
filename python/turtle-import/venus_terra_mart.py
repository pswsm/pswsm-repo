"""Contains the code for drawing plantes venus, earth & mars"""
import turtle


def draw_venus(color: str = "#cd7f32", pos: tuple = (175, 50),
               size: int = 20):
    """Draws Venus.
    Parameter:
        - color -- must be a string. must be a hex color code
        - pos   -- must be a tuple, with at least 2 numbers to be coordinates
        - size  -- must an integer. sets the radius of the planet
    """
    turtle.color(color)
    turtle.penup()
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(size)
    turtle.end_fill()


def draw_terra(color: str = "#0073cf", land_color: str = "#1e4d2b",
               pos: tuple = (200, -150), size: int = 45):
    """Draws a simple earth"""
    turtle.color(color)
    turtle.penup()
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(size)
    turtle.end_fill()
    turtle.color(land_color)
    turtle.pendown()
    turtle.begin_fill()
    turtle.goto(turtle.xcor(), turtle.ycor()+10)
    turtle.circle(15, None, 7)
    turtle.goto(turtle.xcor()+20, turtle.ycor()+30)
    turtle.circle(20, None, 10)
    turtle.end_fill()


def draw_mart(color: str = "#fd0e35", pos: tuple = (-30, -200),
              radius: int = 30):
    """Draws the red planet"""
    turtle.color(color)
    turtle.penup()
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(radius)
    turtle.end_fill()
