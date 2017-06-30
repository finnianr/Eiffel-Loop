pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

# Pyxis is data format inspired by the Python programming language and designed to be a more
# readable supplement/substitute for XML configuration files.

# Pyxis as an acronym stands for: Pythonic XML ideal source.
# It is also a Latin transliteration of a Greek word for a type of pottery used by women to hold 
# cosmetics, trinkets or jewellery. 

# The following is a build script for geant, the GOBO ant build tool.
	
project:
	name = free_elks; default = help

	description:
		"""
			description: "Eiffel Ant file for the FreeELKS Library"
			library: "FreeELKS"
			copyright: "Copyright (c) 2005, Eric Bezault & others"
			license: "MIT License"
			date: "$Date: 2008-04-22 09:12:58 -0700 (Tue, 22 Apr 2008) $"
			revision: "$Revision: 6373 $"
		"""

	target:
		name = help
		echo:
			message = "usage:"
		echo:
			message = "\tgeant install"
		echo:
			message = "\tgeant clean"
		echo:
			message = "\tgeant clobber"

	target:
		name = install
		description:
			"""
				Install the FreeELKS Library.
			"""

	target:
		name = clean
		description:
			"""
				Remove intermediary generated files.
			"""

	target:
		name = clobber
		description:
			"""
				Remove all generated files.
			"""
		geant:
			target = clean

