function(enable_warnings TARGET)
    target_compile_options(${TARGET} PRIVATE
        $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
        -Werror -Wall -Wextra -Wpedantic -Wnon-virtual-dtor -Wno-unused-function -Wno-maybe-uninitialized>)
endfunction()