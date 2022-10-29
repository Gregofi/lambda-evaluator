# Tests the whole pipeline (Parser -> VM)
require "minitest/autorun"
require "lc-evaluator/ast"
require "lc-evaluator/parser"

class PipelineTest < Minitest::Test
    def test_basic_parser
        puts "\n"
        parser = BasicParser.new("((\\x . x) y)")
        p = parser.S
        evaled = p.eval()
        assert_equal("y", evaled.to_s)
    end
end