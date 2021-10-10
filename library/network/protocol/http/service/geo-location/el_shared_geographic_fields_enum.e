note
	description: "Shared instance of [$source EL_GEOGRAPHIC_FIELDS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-10 11:28:55 GMT (Sunday 10th October 2021)"
	revision: "1"

deferred class
	EL_SHARED_GEOGRAPHIC_FIELDS_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Geographic_field: EL_GEOGRAPHIC_FIELDS_ENUM
		once
			create Result.make
		end
end