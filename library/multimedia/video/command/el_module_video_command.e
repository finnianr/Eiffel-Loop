note
	description: "Shared access to instance of ${EL_VIDEO_COMMAND_FACTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_MODULE_VIDEO_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	Video_command: EL_VIDEO_COMMAND_FACTORY
		once
			create Result
		end
end