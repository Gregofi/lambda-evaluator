


def remove_prefix(str, prefix)
    str = str.delete_prefix('(\\')
    str.lstrip!
    str
end

# Is used for parsing the most basic LC syntax:
# Expr -> [A-Z]
# Expr -> (Expr Expr)
# Expr -> (λ [A-Z] . Expr)
#
# Note: This guy is terribly innefective but short and concise
#       The LC expressions are often short anyway and the interpreter
#       will take most time anyway
class BasicParser
    def initialize(input)
        input = input.gsub(')', ' ) ')
        input = input.gsub('(', ' ( ')
        input = input.gsub('\\', ' \\ ')
        input = input.gsub('.', ' ')
        @input = input.split(' ')
    end

    def S
        c = @input.shift
        if (c == '(')
            c = @input.shift
            if (c == "\\")
                param = Identifier.new(@input.shift)
                body  = S()
                expr = LambdaAbstraction.new(param, body)
            else
                @input.unshift(c)
                application = S()
                argument = S()
                expr = Application.new(application, argument)
            end
            raise ArgumentError.new("Expected ')' to close lambda abstraction or application") if @input.shift != ')'
        else
            raise ArgumentError.new("Identifier can only contain letters, got '#{c}'") if !c.match(/\w+/)
            expr = Identifier.new(c)
        end
        expr
    end
end