using CallStack
using Test

const FILE = @__FILE__

foo() = nothing
bar() = foo()
baz() = bar()

buf = IOBuffer()
@callstack buf foo()
@test String(take!(buf)) == 
"""
   1  foo() in Main at $(FILE):6
"""

buf = IOBuffer()
@callstack buf bar()
@test String(take!(buf)) == 
"""
   1  bar() in Main at $(FILE):7
   2    foo() in Main at $(FILE):6
"""

buf = IOBuffer()
@callstack buf baz()
@test String(take!(buf)) == 
"""
   1  baz() in Main at $(FILE):8
   2    bar() in Main at $(FILE):7
   3      foo() in Main at $(FILE):6
"""
