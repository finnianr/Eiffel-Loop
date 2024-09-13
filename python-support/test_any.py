
class Person:
    def __init__(self, name, age, country):
        self.name = name
        self.age = age
        self.country = country

    def __repr__(self):
         return "Person(name='{}', age={})".format(self.name, self.age)

# Tuple containing data
person_data = ("Alice", 30, "USA")

# Initialize the class using * unpacking
person = Person(*person_data)

print person
