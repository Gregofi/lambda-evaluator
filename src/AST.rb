
class Application
    def initialize(exprs)
        @expr = exprs
    end

    def eval()

    end
end

class LambdaAbstraction
    def initialize(parameters, expr)
        @parameters = parameters
        @expr = expr
    end

    def eval()

    end
end

class Identifier
    def initialize(identifier)
        @identifier = identifier
    end

    def eval()

    end
end

class Braces
    def expr(expr)
        @expr = expr
    end

    def eval()
        
    end
end
