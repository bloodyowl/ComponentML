all:
		rm -fr dist
		ocamlopt -c src/Component.ml
		mkdir dist
		ocamlopt graphics.cmxa -o dist/App src/Component.cmx
		open dist/App
