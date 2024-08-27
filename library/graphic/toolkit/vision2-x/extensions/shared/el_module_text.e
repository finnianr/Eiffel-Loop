note
	description: "Shared global instance of object conforming to ${EL_RENDERED_TEXT_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 9:55:20 GMT (Tuesday 27th August 2024)"
	revision: "16"

deferred class
	EL_MODULE_TEXT

inherit
	EL_MODULE

feature {NONE} -- Constants

	Text_: EL_RENDERED_TEXT_ROUTINES
		-- named with underscore to prevent name clashes
		once ("PROCESS")
			create Result.make
		end

end