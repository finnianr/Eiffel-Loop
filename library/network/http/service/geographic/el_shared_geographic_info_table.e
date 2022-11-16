note
	description: "Shared instance of [$source EL_GEOGRAPHIC_INFO_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_SHARED_GEOGRAPHIC_INFO_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Geographic_info_table: EL_GEOGRAPHIC_INFO_TABLE
		once
			create Result.make (11)
		end
end