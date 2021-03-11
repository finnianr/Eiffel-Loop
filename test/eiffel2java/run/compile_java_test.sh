
pushd test-data/java_source
BATIK=$EIFFEL/library/Eiffel-Loop/contrib/Java/batik-1.6.1

export CLASSPATH=$BATIK/batik-rasterizer.jar:$BATIK/batik-transcoder.jar:.
javac -d ../java_classes Eiffel2JavaTest.java com/eiffel_loop/svg/SVG_TO_PNG_TRANSCODER.java

popd
