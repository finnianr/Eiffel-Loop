
export PYTHONPATH=$PYTHONPATH:$EIFFEL/library/Eiffel-Loop/tool/python-support

python -m eiffel_loop.scripts.ec_build_finalized --autotest --install /usr/local/bin
# python -m eiffel_loop.scripts.ec_build_finalized -help

# ec_build_finalized.py --autotest --install /usr/local/bin
