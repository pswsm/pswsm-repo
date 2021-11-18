#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Person:

    def __init__(self, likes: list, name: str, age: int):
       self.likes = likes
       self.name = name
       self.age = age


ady: Person = Person(likes = ['lechuga', 'valorant'], name = 'Ady', age = 22)

print(f'Me llamo {ady.name}, tengo {ady.age} y me gusta:', ' '.join(ady.likes), '.')

