#!/usr/bin/env python
#-- encoding: UTF-8

#made by pswsm

class Square:
    # Constructor
    def __init__(self, x: float, y: float, length: float):
        self.x = x
        self.y = y
        self.length = length
      
    def vertex(self) -> list:
        x_plus = self.x + self.length/2
        x_less = self.x - self.length/2
        y_plus = self.y + self.length/2
        y_less = self.y - self.length/2
        vertex_dr = ((x_plus), (y_less))
        vertex_dl = ((x_less), (y_less))
        vertex_ur = ((x_plus), (y_plus))
        vertex_ul = ((x_less), (y_plus))
        return vertex_dr, vertex_ur, vertex_ul, vertex_dl


s: Square = Square(0, 0, 10)
vertex = s.vertex()
position = ['down-right', 'upper-right', 'upper-left', 'down-left']

for i in range(len(position)):
    print(f'Vertex {position[i]}:\t{vertex[i]}')
