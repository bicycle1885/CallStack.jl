module CallStack

export @callstack

using Cassette: Cassette

mutable struct CallStackState
    output::IO
    serial::Int
    depth::Int
    CallStackState() = new(stderr, 0, 0)
end

const INDENT = "  "

Cassette.@context CallStackContext

function Cassette.prehook(ctx::CallStackContext, f, args...)
    state = ctx.metadata
    if !(f isa Core.Builtin)
        state.serial += 1
        method = first(methods(f, typeof.(args)))
        println(
            # output stream
            state.output,
            # serial
            lpad(state.serial, 4), "  ",
            # indent
            INDENT ^ state.depth,
            # method info
            method,
        )
    end
    state.depth += 1
end

function Cassette.posthook(ctx::CallStackContext, f, args...)
    state = ctx.metadata
    state.depth -= 1
end

macro callstack(fcall)
    quote
        state = CallStackState()
        Cassette.overdub(CallStackContext(metadata = state), () -> $(esc(fcall)))
    end
end

end # module
