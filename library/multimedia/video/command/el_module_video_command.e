note
	description: "Shared access to instance of [$source EL_VIDEO_COMMAND_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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