#!/usr/bin/env python
#-- encoding: UTF-8

#made by pswsm

import turtle


def squareVertices(x: float = 0, y: float = 0, length: float = 100) -> list:
    '''Simulates a square nd returns the vertice coordinates.
    Returns the vertices in clockwise order, starting from the down-right.'''
    vertices = []
    x_plus = x + length/2
    x_less = x - length/2
    y_plus = y + length/2
    y_less = y - length/2
    vertice_dr = ((x_plus), (y_less))
    vertice_dl = ((x_less), (y_less))
    vertice_ur = ((x_plus), (y_plus))
    vertice_ul = ((x_less), (y_plus))
    vertices.extend((vertice_dr, vertice_ur, vertice_ul, vertice_dl))
    return vertices 


vertices = squareVertices(length = 10)
position = ['down-right', 'upper-right', 'upper-left', 'down-left']

for i in range(len(position)):
    print(f'Vertice {position[i]}: {vertices[i]}')

