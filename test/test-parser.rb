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
        parsed = SimplerGrammarParser.new("x").S
        assert_equal("x", parsed.to_s)

        parsed = SimplerGrammarParser.new("x y").S
        assert_equal("(x y)", parsed.to_s)

        parsed = SimplerGrammarParser.new("x y z").S
        assert_equal("((x y) z)", parsed.to_s)

        parsed = SimplerGrammarParser.new("x y z a").S
        assert_equal("(((x y) z) a)", parsed.to_s)

        parsed = SimplerGrammarParser.new("x (y z)").S
        assert_equal("(x (y z))", parsed.to_s)

        parsed = SimplerGrammarParser.new("x (y z) z").S
        assert_equal("((x (y z)) z)", parsed.to_s)

        parsed = SimplerGrammarParser.new("x (y z) (z)").S
        assert_equal("((x (y z)) z)", parsed.to_s)

        parsed = SimplerGrammarParser.new("x y (z z)").S
        assert_equal("((x y) (z z))", parsed.to_s)

        parsed = SimplerGrammarParser.new("(λ t . (λ f . t))").S
        parsed = SimplerGrammarParser.new("(λ t f . t)").S
        assert_equal("(λt. (λf. t))", parsed.to_s)

        parsed = SimplerGrammarParser.new("(λ a b . a T b)").S
        assert_equal("(λa. (λb. ((a T) b)))", parsed.to_s)

        parsed = SimplerGrammarParser.new("(λ a b . a T b) T F").S
        assert_equal("(((λa. (λb. ((a T) b))) T) F)", parsed.to_s)

        parsed = SimplerGrammarParser.new("(λ a b . (λ s z . a s (b s z)))").S
        assert_equal("(λa. (λb. (λs. (λz. ((a s) ((b s) z))))))", parsed.to_s)
    end
end
