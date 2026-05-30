build:
  rheo compile . --pdf --epub --html

watch-pdf:
  rheo watch . --pdf --open

watch-epub:
  rheo watch . --epub --open

link-component component:
  #!/usr/bin/env bash
  set -euo pipefail
  CACHE_PATH=$(typst info -f json | jq -r '.packages."package-cache-path"')
  mkdir -p $CACHE_PATH/preview/{{ component }}
  ln -s $(pwd)/components/{{ component }} $CACHE_PATH/preview/{{ component }}/0.1.0

link-components: (link-component "code-description")