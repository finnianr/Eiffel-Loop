note
	description: "Shared instance of [$source EL_NAME_TRANSLATER_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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