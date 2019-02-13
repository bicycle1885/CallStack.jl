# CallStack.jl

CallStack.jl provides a macro to display a list of executed methods in a function call.
See the following example:

    julia> foo() = nothing
    foo (generic function with 1 method)

    julia> bar() = foo()
    bar (generic function with 1 method)

    julia> baz() = bar()
    baz (generic function with 1 method)

    julia> using CallStack

    julia> @callstack baz()
       1  baz() in Main at REPL[3]:1
       2    bar() in Main at REPL[2]:1
       3      foo() in Main at REPL[1]:1
