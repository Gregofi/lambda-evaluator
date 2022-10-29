def remove_prefix(str, _prefix)
  str = str.delete_prefix('(\\')
  str.lstrip!
  str
end

# Is used for parsing the most basic LC syntax:
# Expr -> [A-Z]
# Expr -> (Expr Expr)
# Expr -> (λ [A-Z] . Expr)
#
# Note: This guy is terribly innefective but short and concise.
#       The LC expressions are often short anyway and the interpreter
#       will take most time anyway
class BasicParser
  def initialize(input)
    input = input.gsub(')', ' ) ')
    input = input.gsub('(', ' ( ')
    input = input.gsub('\\', ' \\ ')
    input = input.gsub('λ', ' \\ ')
    input = input.gsub('.', ' ')
    @input = input.split(' ')
  end

  def S
    c = @input.shift
    if c == '('
      c = @input.shift
      if c == '\\'
        param = Identifier.new(@input.shift)
        body = S()
        expr = LambdaAbstraction.new(param, body)
      else
        @input.unshift(c)
        application = S()
        argument = S()
        expr = Application.new(application, argument)
      end
      raise ArgumentError, "Expected ')' to close lambda abstraction or application" if @input.shift != ')'
    else
      raise ArgumentError, "Identifier can only contain letters, got '#{c}'" unless c.match(/\w+/)

      expr = Identifier.new(c)
    end
    expr
  end
end

# Is used for parsing simpler LC syntax:
# IDENTIFIER  -> [A-Z]+
# ABSTRACTION -> (λ IDENTIFIER {IDENTIFIER}+ . EXPR)
# APPLICATION -> EXPR EXPR {EXPR}+
# PAREN       -> (EXPR)
# EXPR        -> IDENTIFIER | ABSTRACTION | APPLICATION | PAREN
#
# This leads to prettier syntax : '(λ t f . t) a b' is equal to '(((λ t . (λ f . t)) a) b)'
# Beware, application is left associative!
#
# Note: This guy is suffers from the same problems as BasicParser speed-wise
#
# TODO: Rewrite to proper LL(1) parser or use parser generator
class SimplerGrammarParser
  def initialize(input)
    input = input.gsub(')', ' ) ')
    input = input.gsub('(', ' ( ')
    input = input.gsub('\\', ' \\ ')
    input = input.gsub('λ', ' \\ ')
    input = input.gsub('.', ' . ')
    @input = input.split(' ')
  end

  def ABSTRACTION
    c = @input.shift
    return APPLICATION(EXPR()) if c == '.'
    LambdaAbstraction.new(Identifier.new(c), ABSTRACTION())
  end

  # Returns either application or just expression if there is just one
  # x y -> returns application
  # x   -> returns expression 'x'
  def APPLICATION(prev)
    while @input.length != 0 && @input.first != ')'
      exp = EXPR()
      prev = Application.new(prev, exp)
    end
    prev
  end

  def S
    first = EXPR()
    return first if @input.length == 0
    APPLICATION(first)
  end

  def EXPR # -> LambdaExpression
    if @input.first != '('
      expr = Identifier.new(@input.shift)
    else
      @input.shift
      if @input.first == '\\'
        @input.shift
        expr = ABSTRACTION()
        raise ArgumentError.new("Expected ')' to close lambda abstraction") unless @input.shift == ')' # Eat the ending ')'
      else
        expr = APPLICATION(EXPR())
        @input.shift # Eat the ending ')'
      end
    end
    expr
  end
end