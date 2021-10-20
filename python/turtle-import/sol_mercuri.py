import turtle


sun_color = "#ffbf00"
mer_color = "#b2beb5"


def sol():
    """Draws the sun
    """
    turtle.color(sun_color)
    turtle.penup()
    turtle.goto(0, -50)
    turtle.begin_fill()
    turtle.circle(100)
    turtle.end_fill()


def mercuri():
    """Draws planet mercury
    """
    turtle.color(mer_color)
    turtle.penup()
    turtle.goto(100, 150)
    turtle.begin_fill()
    turtle.circle(10)
    turtle.end_fill()
