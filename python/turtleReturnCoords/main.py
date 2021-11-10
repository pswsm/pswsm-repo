#!/usr/bin/env python
#-- encoding: UTF-8

#made by pswsm

import turtle


def squareVertices(x: float = 0, y: float = 0, length: float = 100) -> list:
    '''Simulates a square and returns the vertice coordinates'''
    vertices = []
    vertice_dr = ((x + length/2), (y - length/2))
    vertice_dl = ((x - length/2), (y - length/2))
    vertice_ur = ((x + length/2), (y + length/2))
    vertice_ul = ((x - length/2), (y + length/2))
    vertices.extend((vertice_dr, vertice_ur, vertice_ul, vertice_dl))
    return vertices 


test = squareVertices()

print(test)
