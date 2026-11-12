from pathlib import Path
import sys
source=Path(sys.argv[1]).read_bytes()
assert 0 < len(source) <= 8*1024*1024
with Path(sys.argv[2]).open('w') as out:
 out.write('#include <stddef.h>\nstatic const unsigned char javascript[] = {\n')
 for offset in range(0,len(source),64):out.write(','.join(str(b) for b in source[offset:offset+64])+',\n')
 out.write('};\nconst unsigned char *duckpad_mermaid_javascript(size_t *length) { *length = sizeof(javascript); return javascript; }\n')
