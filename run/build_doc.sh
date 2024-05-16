export EIFFEL_LOOP=$(pwd)
export EIFFEL_LOOP_DOC=$EIFFEL_LOOP/doc
read -p 'Enter a version number: ' version
el_toolkit -publish_repository -config doc-config/config.pyx -version $version
