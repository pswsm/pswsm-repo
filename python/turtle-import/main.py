"""Contains the main code of the solar system"""
import turtle
import sol_mercuri
import venus_terra_mart
import jupiter_saturn


def setup(color: str = "#111", speed: int = 0, size: tuple = (500, 500)):
    """Sets the canvas for the drawing"""
    # turtle.hideturtle()
    turtle.speed(speed)
    turtle.bgcolor(color)
    turtle.setup(size[0], size[1])


setup()
sol_mercuri.draw_sol()
sol_mercuri.draw_mercuri()
venus_terra_mart.draw_venus()
venus_terra_mart.draw_terra()
venus_terra_mart.draw_mart()
jupiter_saturn.draw_jupiter()
jupiter_saturn.draw_saturn()
turtle.done()
