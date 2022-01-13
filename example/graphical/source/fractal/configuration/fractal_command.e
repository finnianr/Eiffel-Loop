note
	description: "Launch GUI of type [$source EL_VISION_2_USER_INTERFACE [FRACTAL_MAIN_WINDOW]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 14:05:15 GMT (Thursday 13th January 2022)"
	revision: "3"

class
	FRACTAL_COMMAND

inherit
	EL_COMMAND

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

	gui: EL_VISION_2_USER_INTERFACE [FRACTAL_MAIN_WINDOW]

end