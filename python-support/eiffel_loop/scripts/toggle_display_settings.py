#!/usr/bin/env python3
"""
Toggle screen resolution between 2560x1440 and 1920x1080,
and Cinnamon text scaling between 1.3 and 1.0 respectively.
Logs the user out after applying changes to allow proper reset.

Usage: toggle_display_settings
"""

import subprocess, sys

from eiffel_loop.x11.environ import SCREEN

# Ordered list of (resolution, text-scaling) pairs — toggle cycles through these

screen = SCREEN ()
scale_list = [('2560x1440', 1.3), ('1920x1080', 1.0)]

def set_text_scaling (scale: float) -> None:
	subprocess.run(
		["gsettings", "set",
		 "org.cinnamon.desktop.interface", "text-scaling-factor",
		 str(scale)],
		check=True,
	)
	print(f"Text scaling factor set to {scale}")

def logout () -> None:
	print("Logging out to apply changes …")
	result = subprocess.run(
		["cinnamon-session-quit", "--logout", "--no-prompt"],
		capture_output=True,
	)
	if result.returncode != 0:
		subprocess.run (["pkill", "-SIGTERM", "-u", subprocess.getoutput ("whoami"), "cinnamon"])

def main () -> None:
	i = 0
	for resolution, scale in scale_list:
		if i > 1 or resolution == screen.resolution:
			break
		else:
			i = i + 1

	if i > 1:
		print(f"ERROR: current resolution {screen.resolution}px does not match any in list", file=sys.stderr)
	else:
		target_resolution, target_scale = scale_list [(i + 1) % 2]

		print (f"Current resolution {scale_list [i][0]}")
		print (f"Switching to {target_resolution}")
		screen.set_resolution (target_resolution)
		set_text_scaling (target_scale)

		if input("Log out now? (y/n): ").strip().lower() == 'y':
			logout()		

if __name__ == "__main__":
	main()
