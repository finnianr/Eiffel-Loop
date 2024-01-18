note
	description: "Shared instance of ${EL_NAME_TRANSLATER_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 10:04:38 GMT (Friday 9th December 2022)"
	revision: "3"

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