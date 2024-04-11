from typing import *
from copy import deepcopy
from dataclasses import dataclass

@dataclass
class ListDeclaration:
    capacity: int
    contains_type: any

class JaniGenerator:

    def _array_indexing_to_name(self, array_name: str, index: int):
        return f"{array_name}__{index}"

    def model(self, obj: any):
        pass

    def constant(self, obj: any):
        # Recursively define objects if it's a list
        if isinstance(obj.type, ListDeclaration):
            constant_definitions = []
            capacity = obj.type.capacity
            for i in range(capacity):
                copied_obj = deepcopy(obj)
                copied_obj.type = obj.type.list.type
                copied_obj.name = self._array_indexing_to_name(obj.name, i)
                constant_definitions.append(self.constant(copied_obj))
            print(constant_definitions)
            return constant_definitions
        constant_declaration = {
            "name": obj.name,
            "type": obj.type,
            "value": obj.value
        }
        print(constant_declaration)
        return constant_declaration

    def type_(self, obj: any):
        if obj.nonrecursive:
            if obj.nonrecursive.bounded:
                return {
                    "kind": "bounded",
                    "base": obj.nonrecursive.bounded,
                    "lower-bound": obj.nonrecursive.lowerBound,
                    "upper-bound": obj.nonrecursive.upperBound
                }
            elif obj.nonrecursive.basic:
                print(str(obj))
                return str(obj)
        else:
            return ListDeclaration(contains_type=obj.type, capacity=obj.capacity)
    def name(self, obj: any):
        if obj.plain:
            return obj.plain
        elif obj.array:
            return self._array_indexing_to_name(obj.array, obj.index)
    def literal(self, obj: any):
        pass
    def automaton(self, obj: any):
        pass
    def variable(self, obj: any):
        pass
    def expression(self, obj: any):
        pass
    def constExpression(self, obj: any):
        print("ConstExpression")
        pass
    def logicalOperation(self, obj: any):
        pass
    def comparison(self, obj: any):
        pass
    def mathOperation(self, obj: any):
        pass
    def productOperation(self, obj: any):
        pass
    def function(self, obj: any):
        pass
    def uniform(self, obj: any):
        pass
    def transition(self, obj: any):
        pass
    def statement(self, obj: any):
        pass
    def assignment(self, obj: any):
        pass
    def prob(self, obj: any):
        pass
    def if_(self, obj: any):
        pass
    def composition(self, obj: any):
        pass

    def preprocessorExpression(self, obj: any):
        # Only math operations exist
        return obj
    def preprocessorLiteral(self, obj: any):
        print("PreprocessorLiteral", obj)
        pass
    def preprocessorMathOperation(self, obj: any):
        return obj
    def preprocessorProductOperation(self, obj: any):
        pass
