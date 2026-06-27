require 'mkmf'

# Builds the optional native extension. Oath falls back to a pure-Ruby
# implementation when this is not compiled, so the build is best-effort.
$CFLAGS << ' -O2'

create_makefile('oath/oath_native')
