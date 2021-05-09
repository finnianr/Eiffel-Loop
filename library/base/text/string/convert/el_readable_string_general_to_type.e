note
	description: "Convert [$source READABLE_STRING_GENERAL] to type `G'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:39:56 GMT (Sunday 9th May 2021)"
	revision: "1"

deferred class
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `G'
		deferred
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): G
		require
			valid_string: is_convertible (str)
		deferred
		end

end