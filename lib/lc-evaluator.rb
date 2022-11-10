require 'lc-evaluator/ast'
require 'lc-evaluator/parser'

# Expects input to not contain any macros!
def single_step(input)
  expr = BasicParser.new(input).TOP
  expr.eval
end

def evaluate(input)
  expr = BasicParser.new(input).TOP
  expr = expr.eval until expr.normal?
  expr.to_s
end
