note
	description: "Basic interface to reflective object useful in parallel inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_REFLECTIVE_I

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_name_list: EL_STRING_LIST [STRING]
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

feature {NONE} -- Constants

	frozen Default_initial_values: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		once
			create Result.make_empty
		end

	frozen Default_reader_writer_interfaces: EL_HASH_TABLE [EL_READER_WRITER_INTERFACE [ANY], TYPE [ANY]]
		once
			create Result
		end

	frozen Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

end