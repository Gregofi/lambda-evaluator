require "lc-evaluator/ast"
require "lc-evaluator/parser"

def evaluate(input)
    expr = BasicParser.new(input).S
    return expr.eval
end
