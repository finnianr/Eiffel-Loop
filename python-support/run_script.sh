export PYTHONPATH=$EIFFEL/library/Eiffel-Loop/python-support

# Uncomment to test if externally set value takes precedence for test_eiffel2java_EIFFEL_CONFIG_FILE.py
# export JDK_HOME=/usr/lib/jvm/java-21-openjdk-amd64

python3 -m eiffel_loop.scripts.$1

