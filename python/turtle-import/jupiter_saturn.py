"""Draws jupiter on draw_jupiter() call, and saturn on draw_saturn() call"""
import turtle


def draw_jupiter(color: str = "#ffe4e1", pos: tuple = (-350, -100),
                 radius: int = 75, storm_color: str = "#ff4f00",
                 eye_color: str = "#000"):
    """Jupiter is too hard, so it draws a surprised face"""
    # Jupiter block [
    turtle.color(color)
    turtle.penup()
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(radius)
    turtle.end_fill()
    # ] Mouth Block [
    turtle.goto(turtle.xcor()-10, turtle.ycor()+20)
    turtle.color(storm_color)
    turtle.begin_fill()
    turtle.circle(15)
    turtle.end_fill()
    # ] Eye Block [
    turtle.goto(turtle.xcor()-20, turtle.ycor()+75)
    turtle.color(eye_color)
    turtle.begin_fill()
    turtle.circle(10)
    turtle.goto(turtle.xcor()+40, turtle.ycor())
    turtle.circle(10)
    turtle.end_fill()
    # ]


def draw_saturn(color: str = "#eda", pos: tuple = (-450, 100),
                ring_color: str = "#f0ffff", radius: int = 70):
    """Draws Saturn"""
    # Saturn Block [
    turtle.color(color)
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(radius)
    turtle.end_fill()
    # ] Halo Block [
    turtle.goto(turtle.xcor()-radius, turtle.ycor()+(radius/2))
    turtle.color(ring_color)
    turtle.seth(-45)
    turtle.pen(pensize=15, pendown=True)
    for i in range(2):
        turtle.circle(radius+30, 90)
        turtle.circle((radius+30)//2, 90)
    # ] Saturn Redraw Block [
    turtle.seth(0)
    turtle.pen(pensize=1, pendown=False)
    turtle.color(color)
    turtle.goto(pos[0], pos[1])
    turtle.begin_fill()
    turtle.circle(radius)
    turtle.end_fill()
    # ]
