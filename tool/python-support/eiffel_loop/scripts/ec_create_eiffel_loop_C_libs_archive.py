import os, subprocess

from distutils import dir_util
from distutils import file_util
from os import path
from subprocess import call

eiffel_loop = 'Eiffel-Loop'
exclusions = 'exclude.txt'
f_code_tar = 'eiffel_loop_c_libs.tar'
f_code_tar_gz = f_code_tar + '.gz'

f = open (exclusions, 'w')
extensions = [
	'a', 'bat', 'cpp', 'c', 'dll', 'exp', 'getdll', 'in',
	'o', 'os', 'obj', 'orig', 'original',
	'pdb', 'py', 'pyc',
	'mingw', 'msc',
	'so', 'txt'
]
for ext in extensions:
	f.write ('*.%s\n' % ext)

for ending in ['conftest*', 'COPYING', 'SConstruct', 'SConscript', 'THANKS']:
	f.write ('*\\%s\n' % ending )

f.close ()

call (['tar', '-cf', f_code_tar, '-X', exclusions, path.join (eiffel_loop, 'C_library')])
call (['tar', '-rvf', f_code_tar, '-X', exclusions, path.join (eiffel_loop, r'contrib\C++')])
call (['tar', '-rvf', f_code_tar, '-X', exclusions, path.join (eiffel_loop, r'contrib\C')])
os.remove (exclusions)

if path.exists (f_code_tar_gz):
	os.remove (f_code_tar_gz)

call (['gzip', f_code_tar])



#call (['tar', '-xf', f_code_tar, '-C', r'build\windows'])

