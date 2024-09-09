#! /usr/bin/env python
import os, string, re, sys

from os import path
from glob import glob
from subprocess import call

for xcf in glob (path.join ('images-full-size', '*.xcf')):
	svg = path.join ('images', path.splitext (path.basename (xcf))[0] + '.svg')
	print svg
	call (['convert', xcf, svg])

