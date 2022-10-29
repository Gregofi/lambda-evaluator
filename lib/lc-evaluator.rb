require 'lc-evaluator/ast'
require 'lc-evaluator/parser'

def single_step(input)
  expr = BasicParser.new(input).S
  expr.eval
end

def evaluate(input)
  expr = BasicParser.new(input).S
  expr = expr.eval until expr.normal?
  expr.to_s
end
