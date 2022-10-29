require "lc-evaluator/ast"
require "lc-evaluator/parser"

def single_step(input)
    expr = BasicParser.new(input).S
    return expr.eval
end

def evaluate(input)
    expr = BasicParser.new(input).S
    while !expr.normal?
        expr = expr.eval
    end
    return expr.to_s
end
