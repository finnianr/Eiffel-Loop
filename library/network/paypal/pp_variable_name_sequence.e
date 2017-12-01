note
	description: "Summary description for {PP_SEQUENTIAL_VARIABLE_NAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 14:45:38 GMT (Thursday 23rd November 2017)"
	revision: "3"

deferred class
	PP_VARIABLE_NAME_SEQUENCE

feature {NONE} -- Implementation

	new_name: ZSTRING
		do
			Result := name_prefix + count.out
		end

	name_prefix: ZSTRING
		deferred
		end

feature -- Measurement

	count: INTEGER
		deferred
		end
end
