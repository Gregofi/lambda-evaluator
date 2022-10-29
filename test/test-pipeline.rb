# Tests the whole pipeline (Parser -> VM)
require "minitest/autorun"
require "lc-evaluator"

class PipelineTest < Minitest::Test
    def test_basic_parser
        evaled = evaluate("((\\x . x) y)")
        assert_equal("y", evaled.to_s)

        evaled = evaluate("((\\x.x)y)")
        assert_equal("y", evaled.to_s)

        evaled = evaluate("((\\t (\\ f . t) ) a)")
        assert_equal("(λf. a)", evaled.to_s)

        evaled = evaluate("(((\\t (\\ f . t) ) a) b)")
        assert_equal(evaled.to_s, "a")
    end

    def test_basic_parser_advanced
        # +
        expr = "(\\ a . (\\ b . (\\ s . (\\ z . ((a s) ( (b s) z ))))))"
        evaled = evaluate(expr)
        assert_equal("(λa. (λb. (λs. (λz. ((a s) ((b s) z))))))", evaled.to_s)
        # 2
        n2 = "(\\ s . (\\ z . (s (s z))))"
        # 3
        n3 = "(\\ s . (\\ z . (s (s (s z)))))"
        # (+ 2 3)
        expr = "((#{expr} #{n2}) #{n3})"
        evaled = evaluate(expr)
        assert_equal("(λs. (λz. (s (s (s (s (s z)))))))", evaled.to_s)
    end
end