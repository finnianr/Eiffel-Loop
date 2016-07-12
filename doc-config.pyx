pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

publish-repository:
	name = "Eiffel-Loop"

	templates:
		main:
			"template.html.evol"
		eiffel-source:
			"source-code.html.evol"

	root-dir:
		"$EIFFEL_LOOP"
	output-dir:
		"workarea/doc"
	github-url:
		"https://github.com/finnianr/eiffel-loop"

	sources:
		tree:
			name = "EROS server"
			"$EIFFEL_LOOP/example/net/eros-server/source"
		tree:
			name = "Eiffel object reflection"
			"$EIFFEL_LOOP/library/base/runtime/reflection"
		tree:
			name = "Eiffel Remote Object Server (EROS)"
			"$EIFFEL_LOOP/library/network/eros"

