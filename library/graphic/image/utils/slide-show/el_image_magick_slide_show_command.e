note
	description: "Generate slides for video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-03 12:14:45 GMT (Friday 3rd June 2022)"
	revision: "4"

class
	EL_IMAGE_MAGICK_SLIDE_SHOW_COMMAND

inherit
	EL_APPLICATION_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		do
			create slide_show.make (config_path)
		end

feature -- Constants

	Description: STRING = "Generate slides for video"

feature -- Basic operations

	execute
		do
			slide_show.generate
		end

feature {NONE} -- Internal attributes

	slide_show: EL_IMAGE_MAGICK_SLIDE_SHOW

end