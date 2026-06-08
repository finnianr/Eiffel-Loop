#!/usr/bin/env python3
"""
Toggle screen resolution between 2560x1440 and 1920x1080,
and apply different Cinnamon font scaling and sizing appropriate for the resolution

Usage: toggle_display_settings
"""

import subprocess, sys
from typing import NamedTuple

from eiffel_loop.x11.environ import SCREEN
from eiffel_loop.os.environ import G_SETTINGS

# Ordered list of (resolution, text-scaling) pairs — toggle cycles through these

class SETTING (NamedTuple):
	resolution: str
	scale: float
	desktop_font_size: int

screen = SCREEN ()

cinnamon_desktop = G_SETTINGS ("org.cinnamon.desktop.interface")

Default_font       = 'font-name'
Desktop_font       = 'desktop-font'
Document_font      = 'document-font-name'
Monospace_font     = 'monospace-font-name'
Text_scaling_factor = 'text-scaling-factor'

cinnamon_windows = G_SETTINGS ( "org.cinnamon.desktop.wm.preferences")
Window_title_font  = 'titlebar-font'

setting_list = [SETTING ('2560x1440', 1.3, 14), SETTING ('1920x1080', 1.0, 12)]

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
	for setting in setting_list:
		if i > 1 or setting.resolution == screen.resolution:
			break
		else:
			i = i + 1

	if i > 1:
		print(f"ERROR: current resolution {screen.resolution}px does not match any in list", file=sys.stderr)
	else:
		target = setting_list [(i + 1) % 2]

		print (f"Current resolution {setting_list [i].resolution}")
		print (f"Switching to {target.resolution}")
		screen.set_resolution (target.resolution)
		
		cinnamon_desktop.set_font_size (Desktop_font, target.desktop_font_size)
		cinnamon_desktop.set (Text_scaling_factor, str (target.scale))

		if input("Log out now? (y/n): ").strip().lower() == 'y':
			logout()		

if __name__ == "__main__":
	main()
