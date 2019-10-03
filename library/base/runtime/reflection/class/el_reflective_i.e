note
	description: "Basic interface to reflective object useful in parallel inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 9:45:23 GMT (Monday 10th June 2019)"
	revision: "4"

deferred class
	EL_REFLECTIVE_I

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_table: EL_REFLECTED_FIELD_TABLE
		deferred
		end

	is_collection_field (basic_type, type_id: INTEGER): BOOLEAN
		deferred
		end

	is_field_convertable_from_string (basic_type, type_id: INTEGER): BOOLEAN
		deferred
		end

end
