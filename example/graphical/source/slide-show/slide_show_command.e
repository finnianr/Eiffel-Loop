note
	description: "Create slides for video"
	notes: "[
		Unfortunately this app has a memory leak possibly due to a bug in GDK API.
		See routine {[$source CAIRO_PIXEL_BUFFER]}**.c_free**.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 14:56:07 GMT (Saturday 11th June 2022)"
	revision: "4"

class
	SLIDE_SHOW_COMMAND

inherit
	EL_APPLICATION_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		local
			config: SLIDE_SHOW
		do
			create config.make (config_path)
		end

feature -- Constants

	Description: STRING = "Create slides for video"

feature -- Basic operations

	execute
		local
			gui: EL_VISION_2_USER_INTERFACE [SLIDE_SHOW_WINDOW, EL_STOCK_PIXMAPS]
		do
			create gui.make (False)
			gui.launch
		end

end