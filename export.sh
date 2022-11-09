#!/usr/bin/env zsh

npx esbuild export/index.ts --bundle \
  --external:pg-native --inject:shims/shims.js --loader:.pem=text \
  --format=esm --target=esnext --platform=neutral --main-fields=main \
  --define:debug=false --minify \
  | (echo 'import tlsWasm from "./tls.wasm";' && cat -) \
  > dist/npm/index.js

curl --silent https://raw.githubusercontent.com/DefinitelyTyped/DefinitelyTyped/master/types/pg/index.d.ts \
  > dist/npm/index.d.ts

echo '
// additions for Neon/WebSocket driver
export const neonConfig: { 
  wsProxy: string | ((host: string) => string);
  rootCerts: string;
  disableSNI: boolean;
}' >> dist/npm/index.d.ts

cp shims/net/tls.wasm dist/npm/
