# nanaca-crash-html
Porting the classic Flash game Nanaca Crash to modern html/css/js

## Local comparison reference

The original Flash build is kept under `import/original-swf/` for development comparisons only; it is not linked from the HTML5 game's UI. Serve the repository over HTTP (the SWF player needs the Ruffle WebAssembly files to be served with the correct MIME type), then open:

```text
http://localhost:8000/import/original-swf/reference.html
```

For example, run `python3 -m http.server` from the repository root. The reference harness uses the locally bundled Ruffle 0.7.1 self-hosted runtime in `import/original-swf/ruffle/`; its MIT and Apache-2.0 notices are included alongside it.
