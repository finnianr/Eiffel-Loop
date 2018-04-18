note
	description: "Numbered variable name sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 11:02:09 GMT (Friday 13th April 2018)"
	revision: "5"

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
