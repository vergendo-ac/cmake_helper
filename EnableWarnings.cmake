function(enable_warnings TARGET)
    target_compile_options(${TARGET} PRIVATE
        $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
        -Werror -Wall -Wextra -Wpedantic -Wnon-virtual-dtor -Wno-unused-function>
        # Disable maybe-uninitialized warning for GCC 8.x and earlier due to false positives
        $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:${CMAKE_CXX_COMPILER_VERSION},9.0>>:
        -Wno-maybe-uninitialized>)
endfunction()
