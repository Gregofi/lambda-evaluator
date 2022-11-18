# Lambda evaluator
Simple naive lambda evaluator written in Ruby.

It has two features extending classic lambda calculus:
- It supports syntactic sugars
    - `(\x. (\y. <E>))` can be written as `(\x y . <E>)`, where `<E>` is some lambda expression
    - `((x y) z)` can be written as `x y z`. Beware, this implicit application is left associative,
      so this `(s (s z))` must still be written with parentheses.
- It supports macros, you can write 
```
T := (\t f . t); 
F := (\t f . f);
NOT := (\x . x T F);
NOT T
```

There are some standard macros defined which you can use, like first 5 numbers, Y-combinator, logical operators and so on.
Use `-h` to see all.

## How to build
Run following commands in the root directory of the project:
```
gem build lc-evaluator.gemspec
gem install lc-evaluator
```
Optionally run the install command with `sudo` to have the binary on your `PATH`.

