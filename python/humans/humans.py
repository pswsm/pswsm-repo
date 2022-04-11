'''Humans in Python'''

from random import choice, randrange


class Blood:
    '''Blood class. Has a fenotype and a genotype'''

    def __init__(self):
        genotype: str = select_string(['aa', 'ab', 'bb', 'bo', 'oo'])
        fenotype: str = select_string(for_genotype=False)


class Human:
    '''
    A human. Has a name, a last name, age and blood type.
    Uses "Blood" class.
    '''

    def __init__(self):
        fname: str = select_string(['pau', 'joan', 'josep', 'gerard', 'jaume'])
        lname: str = select_string(['dsa'])
        age: int = randrange(100)
        state: bool = True
        blood_type: Blood

    def __str__(self):
        return f'''
                Name:\t{self.fname}\nLast Name:\t{self.lname}
                Age:\t{self.age}\nBlood:\t{self.blood_type.fenotype}
                '''


def select_string(strings: list[str]) -> str:
    '''Selects a string from the given list'''
    return choice(strings)


if __name__ == '__main__':
    print(Human())
