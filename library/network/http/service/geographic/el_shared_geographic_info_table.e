note
	description: "Shared instance of [$source EL_GEOGRAPHIC_INFO_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-19 9:27:57 GMT (Sunday 19th June 2022)"
	revision: "3"

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