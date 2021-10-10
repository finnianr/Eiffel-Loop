note
	description: "Shared instance of [$source EL_GEOGRAPHIC_INFO_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-10 12:14:16 GMT (Sunday 10th October 2021)"
	revision: "1"

deferred class
	EL_SHARED_GEOGRAPHIC_INFO_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Geographic: EL_GEOGRAPHIC_INFO_TABLE
		once
			create Result.make
		end
end