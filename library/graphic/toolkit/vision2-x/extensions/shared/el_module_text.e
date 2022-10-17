note
	description: "Shared global instance of object conforming to [$source EL_RENDERED_TEXT_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 13:05:55 GMT (Monday 17th October 2022)"
	revision: "13"

deferred class
	EL_MODULE_TEXT

inherit
	EL_MODULE

feature {NONE} -- Constants

	Text: EL_RENDERED_TEXT_ROUTINES
			--
		once ("PROCESS")
			create Result.make
		end

end