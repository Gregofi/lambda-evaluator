require "minitest/autorun"
require "lc-evaluator/ast"

class ExprTest < Minitest::Test
  def test_basic_eval
    expr = Identifier.new('y')
    expr.eval()
    assert_equal(Identifier.new('y'), expr)
    expr_rep = expr.replace(Identifier.new('y'), Identifier.new('z'))
    assert_equal(Identifier.new('z'), expr_rep)
    # Check that replace doesn't mutate
    assert_equal(Identifier.new('y'), expr)

    expr = Application.new(Identifier.new('x'), Identifier.new('y'))
    assert(expr.normal?)
    evaled_expr = expr.eval()
    # Should do nothing
    assert_equal(Application.new(Identifier.new('x'), Identifier.new('y')).to_s, evaled_expr.to_s)
    assert_equal(Application.new(Identifier.new('x'), Identifier.new('y')).to_s, expr.to_s)

    expr = Application.new(
            LambdaAbstraction.new(
                Identifier.new('x'),
                Identifier.new('x')
            ),
            Identifier.new('y'))
    assert(!expr.normal?)
    evaled_expr = expr.eval()
    assert(evaled_expr.normal?)
    assert_equal(Identifier.new('y'), evaled_expr)
    
    # Argument is something more complicated than identifier
    expr = Application.new(
        LambdaAbstraction.new(
            Identifier.new('x'),
            Identifier.new('x')
        ),
        Application.new(
            Identifier.new('y'),
            Identifier.new('z')
            ))
        evaled_expr = expr.eval()
        assert_equal(Application.new(Identifier.new('y'), Identifier.new('z')).to_s, evaled_expr.to_s)
    end
        
    def test_complicated_expressions
        expr = Application.new(
            Application.new(
                LambdaAbstraction.new(
                    Identifier.new('t'),
                    LambdaAbstraction.new(
                        Identifier.new('f'),
                        Identifier.new('t')
                    )
                ),
                Identifier.new('a')
            ),
            Identifier.new('b')
        )
        assert(!expr.normal?)
        evaled_expr = expr.eval()
        puts evaled_expr
    end
end
