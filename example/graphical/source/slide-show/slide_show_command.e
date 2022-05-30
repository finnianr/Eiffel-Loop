note
	description: "Create slides for video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-29 12:25:45 GMT (Sunday 29th May 2022)"
	revision: "2"

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
			gui: EL_VISION_2_USER_INTERFACE [SLIDE_SHOW_WINDOW]
		do
			create gui.make (False)
			gui.launch
		end

end