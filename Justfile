build:
  rheo compile . --pdf --epub --html

watch-pdf:
  rheo watch . --pdf --open

watch-epub:
  rheo watch . --epub --open

cache_path := shell("typst info -f json | jq -r '.packages[\"package-cache-path\"]'")

link-component component:
  mkdir -p {{ cache_path }}/preview/{{ component }}
  ln -s $(pwd)/components/{{ component }} {{ cache_path }}/preview/{{ component }}/0.1.0

link-components: (link-component "code-description")