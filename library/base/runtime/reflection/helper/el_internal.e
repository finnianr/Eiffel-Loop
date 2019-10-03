note
	description: "Internal reflection routines accessible via [$source EL_MODULE_EIFFEL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 11:11:51 GMT (Thursday   3rd   October   2019)"
	revision: "7"

class
	EL_INTERNAL

inherit
	INTERNAL

	SED_UTILITIES
		export
			{ANY} abstract_type
		end

	EL_REFLECTOR_CONSTANTS

feature -- Type queries

	field_conforms_to_collection (basic_type, type_id: INTEGER): BOOLEAN
		-- True if `type_id' conforms to COLLECTION [X] where x is a string or an expanded type
		do
			if is_reference (basic_type) then
				Result := String_collection_type_table.has_conforming (type_id)
								or else Numeric_collection_type_table.has_conforming (type_id)
								or else Other_collection_type_table.has_conforming (type_id)
			end
		end

	field_conforms_to_date_time (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := is_reference (basic_type) and then field_conforms_to (type_id, Date_time_type)
		end

	field_conforms_to_one_of (basic_type, type_id: INTEGER; types: ARRAY [INTEGER]): BOOLEAN
		-- True if `type_id' conforms to one of `types'
		do
			Result := is_reference (basic_type) and then conforms_to_one_of (type_id, types)
		end

	is_reference (basic_type: INTEGER): BOOLEAN
		do
			Result := basic_type = Reference_type
		end

	is_storable_type (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			inspect basic_type
				when Reference_type then
					Result := String_type_table.type_array.has (type_id) or else Storable_type_table.has_conforming (type_id)
				when Pointer_type then
					Result := False
			else
				Result := True
			end
		end

	is_string_or_expanded_type (basic_type, type_id: INTEGER): BOOLEAN
		do
			inspect basic_type
				when Reference_type then
					Result := String_type_table.type_array.has (type_id)
				when Pointer_type then
			else
				Result := True
			end
		end

	is_type_convertable_from_string (basic_type, type_id: INTEGER): BOOLEAN
		-- True if field is either an expanded type (with the exception of POINTER) or conforms to one of following types
		-- 	STRING_GENERAL, EL_DATE_TIME, EL_MAKEABLE_FROM_STRING_GENERAL, BOOLEAN_REF, EL_PATH
		do
			inspect basic_type
				when Reference_type then
					Result := String_type_table.type_array.has (type_id)
									or else String_convertable_type_table.has_conforming (type_id)
									or else Makeable_from_string_type_table.has_conforming (type_id)

				when Pointer_type then
					-- Exclude pointer
			else
				-- is expanded type
				Result := True
			end
		end

feature -- Access

	reflected (a_object: ANY): EL_REFLECTED_REFERENCE_OBJECT
		do
			create Result.make (a_object)
		end

feature {NONE} -- Implementation

	conforms_to_one_of (type_id: INTEGER; types: ARRAY [INTEGER]): BOOLEAN
		-- True if `type_id' conforms to one of `types'
		local
			i: INTEGER
		do
			from i := 1 until Result or i > types.count loop
				Result := field_conforms_to (type_id, types [i])
				i := i + 1
			end
		end

end
