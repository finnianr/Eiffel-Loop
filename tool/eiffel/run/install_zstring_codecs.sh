# Finnian Reilly 12th Feb 2019

EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop

el_eiffel -zcodec_generator \
	-c_source $EIFFEL_LOOP/contrib/C/VTD-XML-2.7/source/decoder.c \
	-template doc/zcodec/template.evol

echo Note\: \(class EL_ISO_8859_1_ZCODEC is not generated\)

for name in iso windows; do
	echo Installing classes\: workarea/el_${name}_\* 
	mv workarea/el_${name}_*.e $EIFFEL_LOOP/library/base/text/zstring/codec/$name
done

