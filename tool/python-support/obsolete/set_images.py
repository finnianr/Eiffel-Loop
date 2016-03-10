#! /usr/bin/env python
import os, string, re, sys

from os import path
from glob import glob
from subprocess import call

for xcf in glob (path.join ('images-full-size', '*.xcf')):
	png = path.join ('images', path.splitext (path.basename (xcf))[0] + '.png')
	print png
	call (['convert', xcf, '-resize', '40%', png])

