# Finnian Reilly 12th Feb 2019

EIFFEL_LOOP=/home/finnian/dev/Eiffel/Eiffel-Loop
pushd .

cd $EIFFEL_LOOP/library/base/text/string/zstring/codec
el_eiffel -generate_codecs -logging -c_source $EIFFEL_LOOP/contrib/C/VTD-XML.2.7/source/decoder.c -template codec_template.evol
mv el_iso_*.e iso
mv el_windows_*.e windows

popd
