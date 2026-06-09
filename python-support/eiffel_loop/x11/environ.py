#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "7 June 2026"
#	revision: "1.0"

import subprocess

class SCREEN:

	# current X11 screen

	def __init__ (self):
		# Works xrandr on Linux with X11

		result = subprocess.run (
			["xrandr", "--query"], capture_output=True, text=True, check=True
		)
		self.name = None
		for line in result.stdout.splitlines():
			if " connected" in line:
				parts = line.split ()
				self.name = parts[0]
				self.resolution = parts[3][0:-4]
				self._update_dimensions ()
				break
				
		if not self.name:
			raise RuntimeError ("No connected display found in xrandr query output")

# Status change
		
	def set_resolution (self, resolution: str) -> None:
		# change display resolution for 'self.name'
		
		print (f"Setting resolution to {resolution} on display '{self.name}'")
		subprocess.run (
			["xrandr", "--output", self.name, "--mode", resolution], check=True,
		)
		self.resolution = resolution
		self._update_dimensions ()
		
# Implementation

	def _update_dimensions (self):
		parts = self.resolution.split ('x')
		self.width = int (parts [0])
		self.height = int (parts [1])
	
