import turtle


def venus():
    """Draws Venus
    """
    turtle.color("#cd7f32")
    turtle.penup()
    turtle.goto(175, 50)
    turtle.begin_fill()
    turtle.circle(20)
    turtle.end_fill()


def terra():
    """Draws a simple earth
    """
    turtle.color("#0073cf")
    turtle.penup()
    turtle.goto(200, -150)
    turtle.begin_fill()
    turtle.circle(45)
    turtle.end_fill()
    turtle.color("#1e4d2b")
    turtle.pendown()
    turtle.begin_fill()
    turtle.goto(turtle.xcor(), turtle.ycor()+10)
    turtle.circle(15, None, 7)
    turtle.goto(220, -120)
    turtle.circle(20, None, 10)
    turtle.end_fill()


def mart():
    """Draws the red planet
    """
    turtle.color("#fd0e35")
    turtle.penup()
    turtle.goto(-30, -150)
    turtle.begin_fill()
    turtle.circle(30)
    turtle.end_fill()
