note
	description: "Shared instance of [$source EL_NAME_TRANSLATER_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-26 9:29:41 GMT (Sunday 26th June 2022)"
	revision: "1"

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