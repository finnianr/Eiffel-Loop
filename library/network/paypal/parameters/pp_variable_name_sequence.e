note
	description: "Numbered variable name sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	PP_VARIABLE_NAME_SEQUENCE

feature {NONE} -- Implementation

	new_name: ZSTRING
		do
			Result := name_template #$ inserts
		end

	inserts: TUPLE
		-- variables to be inserted into `new_name'
		do
			Result := [count]
		end

	name_template: ZSTRING
		deferred
		ensure then
			valid_place_holder_count: Result.occurrences ('%S') = inserts.count
		end

feature -- Measurement

	count: INTEGER
		deferred
		end
end