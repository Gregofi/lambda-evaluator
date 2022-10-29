
class Application
    def initialize(function, argument)
        @function = function
        @argument = argument
    end

    def eval()
        if @function.is_a? LambdaAbstraction
            @function.apply(@argument)
        elsif !@function.normal?
            Application.new(@function.eval, @argument)
        else
            Application.new(@function, @argument.eval)
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
        f = @function.replace(what, val)
        a = @argument.replace(what, val)
        Application.new(f, a)
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
        LambdaAbstraction.new(@parameter, @expr.eval())
    end

    def replace(what, val)
        return self if what == @parameter
        LambdaAbstraction.new(@parameter, @expr.replace(what, val))
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

class Macro
    def initialize(name, expr)
        @expr = expr
    end

    def eval() = @expr

    def normal? = false

    def replace(what, val)
    end

    def to_s = @name
end
