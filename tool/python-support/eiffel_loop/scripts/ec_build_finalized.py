#! /usr/bin/env python

import os, sys, platform, datetime, codecs

from os import path
from subprocess import call
from optparse import OptionParser
from glob import glob

# Word around for bug "LookupError: unknown encoding: cp65001"
if platform.system () == "Windows":
	codecs.register (lambda name: codecs.lookup ('utf-8') if name == 'cp65001' else None)

usage = "usage: python create_installer [--x86]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-x", "--x86", action="store_true", dest="build_x86", default=False, help="Build a 32 bit version in addition to 64 bit"
)
(options, args) = parser.parse_args()

target_architectures = ['x64']

if options.build_x86:
	target_architectures.append ('x86')
	
# Update project ECF file
pecf_name = glob ("*.pecf")[0]
project_name = path.splitext (pecf_name)[0]
pecf_file = open (pecf_name, "a")
pecf_file.write ("\t\t# Build %s\n" % str (datetime.datetime.now ()))
pecf_file.close ()

call (['el_toolkit2', '-pyxis_to_xml', '-in', pecf_name])

# Build for each architecture
if platform.system () == "Windows":
	build_cmd = ['python', path.join (os.path.dirname (os.path.realpath (sys.executable)), 'scons.py')]
else:
	build_cmd = ['scons']

for cpu_target in target_architectures:
	call ( build_cmd + ['cpu=' + cpu_target, 'action=finalize', 'project=%s.ecf' % project_name])

