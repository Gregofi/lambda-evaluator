# Tests the whole pipeline (Parser -> VM)
require "minitest/autorun"
require "lc-evaluator"

class PipelineTest < Minitest::Test
    def test_basic_parser
        evaled = evaluate("((\\x . x) y)")
        assert_equal("y", evaled.to_s)

        evaled = evaluate("((\\x.x)y)")
        assert_equal("y", evaled.to_s)

        evaled = evaluate("(((\\t (\\ f . t) ) a) b)")
        assert_equal("a", evaled.to_s)
    end
end