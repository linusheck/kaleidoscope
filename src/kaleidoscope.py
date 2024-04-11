import textx
import argparse
import sys
from jani import JaniGenerator

Meta = textx.metamodel_from_file("src/kaleidoscope.tx")

def compile(filename):
    # for constant in program.constants:
    #     print(constant)
    # for automaton in program.automata:
    #     print(automaton)
    #     for variable in automaton.variables:
    #         print(variable)
    #     for transition in automaton.transitions:
    #         print(transition)
    #         print(transition.action)
    #         print(transition.guard)
    #         for statement in transition.statements:
    #             print(statement)
    gen = JaniGenerator()
    Meta.register_obj_processors({
        "Model": gen.model,
        "Constant": gen.constant,
        "Type": gen.type_,
        "Name": gen.name,
        "Literal": gen.literal,
        "PreprocessorLiteral": gen.preprocessorLiteral,
        "Automaton": gen.automaton,
        "Variable" :gen.variable,
        "Expression" :gen.expression,
        "ConstExpression" :gen.constExpression,
        "PreprocessorExpression" :gen.preprocessorExpression,
        "LogicalOperation": gen.logicalOperation,
        "Comparison": gen.comparison,
        "MathOperation": gen.mathOperation,
        "PreprocessorMathOperation": gen.preprocessorMathOperation,
        "ProductOperation": gen.productOperation,
        "PreprocessorProductOperation": gen.preprocessorProductOperation,
        "Function": gen.function,
        "Uniform": gen.uniform,
        "Transition": gen.transition,
        "Statement": gen.statement,
        "Assignment": gen.assignment,
        "Prob": gen.prob,
        "If": gen.if_,
        "Composition": gen.composition,
    })
    program = Meta.model_from_file(filename)

def main():
    parser = argparse.ArgumentParser(description="Kaleidoscope compiler")
    
    parser.add_argument("filename", nargs="?", help="Input file")
    parser.add_argument("--file", "-f", dest="filename", help="Input file")

    args = parser.parse_args()

    if not args.filename:
        print("Error: Please provide an input file.", file=sys.stderr)
        parser.print_help()
        return

    # Now you can use args.filename as the input file
    compile(args.filename)

if __name__ == "__main__":
    main()