note
	description: "Shared instance of ${EL_NAME_TRANSLATER_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 9:45:08 GMT (Tuesday 8th April 2025)"
	revision: "5"

deferred class
	EL_SHARED_NAME_TRANSLATER_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Case: EL_CASE
		once
			create Result
		end

	Translater_table: EL_NAME_TRANSLATER_TABLE
		once
			create Result.make
		end

end