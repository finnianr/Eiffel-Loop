export EIFFEL_LOOP=/home/finnian/dev/Eiffel/Eiffel-Loop
el_toolkit2 -manifest -sources "$EIFFEL_LOOP/toolkit-sources.pyx" \
	-source_root "$EIFFEL_LOOP" \
	-output "$EIFFEL_LOOP/toolkit-index.html" \
	-title "Eiffel Loop Classes"
