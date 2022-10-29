
class Application
    def initialize(function, argument)
        @function = function
        @argument = argument
    end

    def eval()
        if @function.is_a? LambdaAbstraction
            return @function.apply(@argument)
        elsif !@function.normal?
            @function.eval
        else
            @argument.eval()
            return self
        end
    end

    def normal?
        if @function.is_a? LambdaAbstraction
            false
        else
            @function.normal? && @argument.normal?
        end
    end

    def replace(what, val)
        @function.replace(what, val)
        @argument.replace(what, val)
    end

    def to_s = "(#{@function.to_s} #{@argument.to_s})"
end

class LambdaAbstraction
    # parameter is string, expr is Lambda expression
    def initialize(parameter, expr)
        @parameter = parameter
        @expr = expr
    end

    def apply(argval)
        res = @expr.replace(@parameter, argval)
        return res
    end

    def normal? = @expr.normal?

    def eval()
        expr.eval()
        return self
    end

    def replace(what, val)
        return if what == @parameter
        @expr.replace(what, val)
    end

    def to_s = "(λ#{@parameter}. #{@expr.to_s})"
end

class Identifier
    attr_reader :identifier

    def initialize(identifier)
        @identifier = identifier
    end

    def eval() = self

    def normal? = true

    def replace(what, val)
        raise ArgumentError.new("Expression to be replaced must be identifier, but is \"#{what}\"") if !what.is_a? Identifier
        if identifier == what.identifier
            return val
        else
            return self
        end
    end

    def to_s = @identifier.to_s

    def eql?(other)
        @identifier.eql?(other.identifier)
    end

    def ==(other) = identifier == other.identifier
end
