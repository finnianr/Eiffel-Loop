note
	description: "Shared instance of ${EL_GEOGRAPHIC_INFO_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 14:36:57 GMT (Thursday 11th July 2024)"
	revision: "6"

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