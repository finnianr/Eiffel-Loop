note
	description: "Fractal command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 14:11:38 GMT (Wednesday 29th May 2019)"
	revision: "1"

class
	FRACTAL_COMMAND

inherit
	EL_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config: FRACTAL_CONFIG)
		do
			create gui.make (True)
		end

feature -- Basic operations

	execute
		do
			gui.launch
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION2_USER_INTERFACE [FRACTAL_MAIN_WINDOW]

end
