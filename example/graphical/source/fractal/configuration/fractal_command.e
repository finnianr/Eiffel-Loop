note
	description: "Launch GUI of type ${EL_VISION_2_USER_INTERFACE [FRACTAL_MAIN_WINDOW]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	FRACTAL_COMMAND

inherit
	EL_APPLICATION_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config: FRACTAL_CONFIG)
		do
			create gui.make (True)
		end

feature -- Constants

	Description: STRING = "Simple geometric fractal defined by Pyxis configuration file"

feature -- Basic operations

	execute
		do
			gui.launch
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION_2_USER_INTERFACE [FRACTAL_MAIN_WINDOW, EL_STOCK_PIXMAPS]

end