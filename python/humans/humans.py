'''Humans in Python'''

from random import choice, randrange


class Blood:
    '''Blood class. Has a fenotype and a genotype'''

    def __init__(self):
        genotype: str = self.generate_enotype()
        fenotype: str = self.generate_enotype(for_genotype=False)

    def generate_genotype(self, for_genotype=True) -> str:
        '''Selects a string from the tuple'''
        genotypes: tuple[str] = ('aa', 'bb', 'ab', 'ao', 'bo', 'oo')
        fenotypes: tuple[str] = ('a', 'b', 'o')
        if for_genotype:
            return choice(genotypes)
        return choice(fenotypes)


class Human:
    '''
    A human. Has a name, a last name, age and blood type.
    Uses "Blood" class.
    '''

    def __init__(self):
        fname: str = self.select_string()
        lname: str = self.select_string(for_fname=False)
        age: int = randrange(100)
        blood_type: Blood

    def __str__(self):
        return f'''
                Name:\t{self.fname}\nLast Name:\t{self.lname}
                Age:\t{self.age}\nBlood:\t{self.blood_type.fenotype}
                '''

    def select_string(self, for_fname=True) -> str:
        '''Selects a string from the tuple'''
        possible_fnames: tuple[str, str, str, str] = (
            'pau', 'joan', 'pabl', 'josep')
        possible_lnames: tuple[str, str, str, str] = (
            'miø', 'jove', 'gean', 'jran')
        if for_fname:
            return choice(possible_fnames)
        return choice(possible_lnames)


if __name__ == '__main__':
    print(Human())
