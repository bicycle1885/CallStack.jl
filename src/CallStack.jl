module CallStack

export @callstack

using Cassette: Cassette

mutable struct CallStackState
    output::IO
    serial::Int
    depth::Int
    CallStackState(output::IO) = new(output, 0, 0)
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

function gencallstack(fcall; output = stderr)
    quote
        state = CallStackState($(esc(output)))
        Cassette.overdub(CallStackContext(metadata = state), () -> $(esc(fcall)))
    end
end

macro callstack(fcall)
    gencallstack(fcall)
end

macro callstack(output, fcall)
    gencallstack(fcall, output = output)
end

end # module
