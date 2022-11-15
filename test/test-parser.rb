require 'minitest/autorun'
require 'lc-evaluator/parser'

class ExprTest < Minitest::Test
  def test_basic_parser
    parser = BasicParser.new('x')
    expr = parser.S
    assert_equal(Identifier.new('x'), expr)

    parser = BasicParser.new('(x y)')
    expr = parser.S
    assert_equal('(x y)', expr.to_s)

    parser = BasicParser.new('(\\x. y)')
    expr = parser.S
    assert_equal(LambdaAbstraction.new(Identifier.new('x'), Identifier.new('y')).to_s, expr.to_s)
  end
end

class AdvancedParser < Minitest::Test
  def test_lambdas
    parsed = SimplerGrammarParser.new('x').TOP
    assert_equal('x', parsed.to_s)

    parsed = SimplerGrammarParser.new('x y').TOP
    assert_equal('(x y)', parsed.to_s)

    parsed = SimplerGrammarParser.new('x y z').TOP
    assert_equal('((x y) z)', parsed.to_s)

    parsed = SimplerGrammarParser.new('x y z a').TOP
    assert_equal('(((x y) z) a)', parsed.to_s)

    parsed = SimplerGrammarParser.new('x (y z)').TOP
    assert_equal('(x (y z))', parsed.to_s)

    parsed = SimplerGrammarParser.new('x (y z) z').TOP
    assert_equal('((x (y z)) z)', parsed.to_s)

    parsed = SimplerGrammarParser.new('x (y z) (z)').TOP
    assert_equal('((x (y z)) z)', parsed.to_s)

    parsed = SimplerGrammarParser.new('x y (z z)').TOP
    assert_equal('((x y) (z z))', parsed.to_s)

    parsed = SimplerGrammarParser.new('(λ t . (λ f . t))').TOP
    parsed = SimplerGrammarParser.new('(λ t f . t)').TOP
    assert_equal('(λt. (λf. t))', parsed.to_s)

    parsed = SimplerGrammarParser.new('(λ a b . a T b)').TOP
    assert_equal('(λa. (λb. ((a T) b)))', parsed.to_s)

    parsed = SimplerGrammarParser.new('(λ a b . a T b) T F').TOP
    assert_equal('(((λa. (λb. ((a T) b))) T) F)', parsed.to_s)

    parsed = SimplerGrammarParser.new('(λ a b . (λ s z . a s (b s z)))').TOP
    assert_equal('(λa. (λb. (λs. (λz. ((a s) ((b s) z))))))', parsed.to_s)
  end
end

class MacroTest < Minitest::Test
  def test_macro
    parsed = BasicParser.new('IDENTITY := (\\x. x); (IDENTITY x)').TOP
    assert_equal('(IDENTITY x)', parsed.to_s)
    parsed = BasicParser.new('IDENTITY := (\\x. x); ADD := y; x').TOP
    assert_equal('x', parsed.to_s)
    parsed = BasicParser.new('X := x; Y := y; (X Y)').TOP
    assert_equal('(X Y)', parsed.to_s)
  end

  def test_advanced_parser_macro
    parsed = SimplerGrammarParser.new('T := (\\t f . t); F := (\\t f . f); NOT := (\\x t f . x f t); (NOT T)').TOP
    assert_equal('(NOT T)', parsed.to_s)
  end
end
