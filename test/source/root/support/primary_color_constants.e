note
	description: "Primary color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 15:30:23 GMT (Wednesday 29th May 2024)"
	revision: "2"

deferred class
	PRIMARY_COLOR_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Colors

	Blue: INTEGER = 2

	Green: INTEGER = 3

	Red: INTEGER = 1

feature {NONE} -- Constants

	Color_table: EL_IMMUTABLE_NAME_TABLE [INTEGER]
		once
			create Result.make (<< Red, Blue, Green >>, "Red, Blue, Green")
		end

end