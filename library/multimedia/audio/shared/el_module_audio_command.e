note
	description: "Shared access to instance of [$source EL_AUDIO_COMMAND_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 15:47:40 GMT (Friday 3rd April 2020)"
	revision: "8"

deferred class
	EL_MODULE_AUDIO_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	Audio_command: EL_AUDIO_COMMAND_FACTORY
		once
			create Result
		end
end
