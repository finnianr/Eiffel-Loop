# localization for I18N_AUTOTEST_APP

export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
el_eiffel -compile_translations -manifest localization/manifest.txt

ec_install_resources.py
