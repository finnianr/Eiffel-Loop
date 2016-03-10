# Finnian Reilly 30th August 2014
EIFFEL_LOOP=/mnt/Development/Eiffel/Eiffel-Loop
cd $EIFFEL_LOOP/library/text/string/codecs
el_toolkit2 -generate_codecs -logging -c_source $EIFFEL_LOOP/contrib/C/VTD-XML.2.7/source/decoder.c -template codec_template.evol
mv el_iso_*.e iso
mv el_windows_*.e windows
