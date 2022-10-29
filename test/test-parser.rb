require "minitest/autorun"
require "lc-evaluator/parser"

class ExprTest < Minitest::Test
    def test_basic_parser
        parser = BasicParser.new("x")
        expr = parser.S
        assert_equal(Identifier.new('x'), expr)

        parser = BasicParser.new("(x y)")
        expr = parser.S
        assert_equal("(x y)", expr.to_s)

        parser = BasicParser.new("(\\x. y)")
        expr = parser.S
        assert_equal(LambdaAbstraction.new(Identifier.new("x"), Identifier.new("y")).to_s, expr.to_s)
    end
end

class AdvancedParser < Minitest::Test
    def test_lambdas
        parsed = SimplerGrammarParser.new("(λ t (λ f . t))").S
        parsed = SimplerGrammarParser.new("(λ t f . t)").S
        assert_equal("(λt. (λf. t))", parsed.to_s)

        assert_raises { SimplerGrammarParser.new("(λ.t)").S }

    end
end
