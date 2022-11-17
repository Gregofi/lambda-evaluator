require 'optparse'

require 'lc-evaluator/ast'
require 'lc-evaluator/parser'

$default_macros = %{
0 := (\\ s z . z);
1 := (\\ s z . s z);
2 := (\\ s z . s (s z));
3 := (\\ s z . s (s (s z)));
4 := (\\ s z . s (s (s (s z))));
5 := (\\ s z . s (s (s (s (s z)))));
ADD := (\\ x y s z . x s (y s z));
MUL := (\\ x y s . x (y s));
T := (\\ t f . t);
F := (\\ t f . f);
NOT := (\\ x . x F T);
OR  := (\\ x y . x T y);
AND := (\\ x y . x y F);
Y := (\\ f . (\\ x . f (x x)) (\\ x . f (x x)));
ZERO? := (\\ n . n (\\ x . T F));
}.freeze()

# Expects input to not contain any macros!
# Does single step of the evaluation
def single_step(input)
  expr = BasicParser.new(input).TOP
  expr.eval
end

# Evaluates expression until it is in normal form
def evaluate(input)
  expr = BasicParser.new(input).TOP
  expr = expr.eval until expr.normal?
  expr.to_s
end

def eval_file(input, parser_type)
  expr = parser_type.new($default_macros + input).TOP
  expr = expr.eval until expr.normal?
  expr.to_s
end

def Repl(parser)
  loop do
    print "> "
    input = gets
    
    if input == nil
      break
    end

    puts ($default_macros + input)
    expr = parser.new($default_macros + input).TOP
    while !expr.normal?
      print ">> #{expr}\n"
      print "[s]ingle step, [e]valuate\n"
      s = gets.chomp
      if s == "s"
        expr = expr.eval
      elsif s == "e"
        expr = expr.eval until expr.normal?
      else
        raise ArgumentError.new("Expected either `s` or `e`")
      end
    end
    print "Expression is in normal form:\n"
    print "  #{expr}\n"
  end
end

def main()
  options = {}
  parser = SimplerGrammarParser
  file = nil
  
  OptionParser.new do |opts|
    opts.banner = 'Usage: lc [options]'
    opts.on("-b", "--basic-parser", "Uses basic parser which can parse only basic LC, no syntactic sugars are used") do
      parser = BasicParser
    end

    opts.on("-h", "--help", "Prints help") do
      puts opts
      exit
    end

    opts.on("-f", "--file", "Input file with lambda code") do |v|
      file = v
    end
  end.parse!

  if file != nil
    input = File.read(file)
    print(eval_file(input))
  else
    Repl(parser);
  end
end
