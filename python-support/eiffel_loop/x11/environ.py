#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "7 JUne 2026"
#	revision: "0.1"

import subprocess, sys

import ctypes
from ctypes import c_int, c_void_p, c_uint, POINTER

class SCREEN:
	# current X11 screen

	def __init__ (self):
		# Return the screen width in pixels using direct Xlib calls.
		# Works on Linux with X11 (standard on most desktops).

		# Load libX11 (usually present on any X11 system)
		X11 = ctypes.cdll.LoadLibrary("libX11.so.6")

		# Define required types and functions
		X11.XOpenDisplay.argtypes = [ctypes.c_char_p]
		X11.XOpenDisplay.restype = c_void_p
		X11.XDefaultScreen.argtypes = [c_void_p]
		X11.XDefaultScreen.restype = c_int
		
		# screen width
		X11.XWidthOfScreen.argtypes = [c_void_p]   # actually takes Screen*, but we pass screen handle
		X11.XWidthOfScreen.restype = c_int

		# screen height
		X11.XHeightOfScreen.argtypes = [c_void_p]   # actually takes Screen*, but we pass screen handle
		X11.XHeightOfScreen.restype = c_int

		# Open connection to the X server (None = use $DISPLAY)
		display = X11.XOpenDisplay(None)
		if not display:
		  raise RuntimeError ("Cannot open X display (is DISPLAY set?)")

		# Get default screen number, then the screen structure pointer
		screen_num = X11.XDefaultScreen(display)
		# X11.XScreenOfDisplay(display, screen_num) would return a Screen*
		# But XWidthOfScreen expects a Screen* – we can get it via XScreenOfDisplay
		X11.XScreenOfDisplay.argtypes = [c_void_p, c_int]
		X11.XScreenOfDisplay.restype = c_void_p
		screen = X11.XScreenOfDisplay(display, screen_num)

		self.width = X11.XWidthOfScreen(screen); self.height = X11.XHeightOfScreen(screen)
		self.resolution = f"{self.width}x{self.height}"
		
		X11.XCloseDisplay (display)
		
		
	def set_resolution (self, resolution: str) -> None:
		result = subprocess.run(
			["xrandr", "--query"], capture_output=True, text=True, check=True
		)
		output_name = None
		for line in result.stdout.splitlines():
			if " connected" in line:
				output_name = line.split()[0]
				break

		if output_name is None:
			print("ERROR: no connected xrandr output found", file=sys.stderr)
			sys.exit(1)

		subprocess.run (
			["xrandr", "--output", output_name, "--mode", resolution], check=True,
		)
		print (f"Resolution set to {resolution} on output '{output_name}'")
		self.resolution = resolution
		parts = resolution.split ('x')
		self.width = int (parts [0]); self.height = int (parts [1])
		

