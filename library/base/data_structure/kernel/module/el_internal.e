note
	description: "Internal reflection routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 20:36:39 GMT (Monday 10th June 2019)"
	revision: "3"

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
				Result := conforms_to_one_of (type_id, String_collection_type_table.type_array)
								or else conforms_to_one_of (type_id, Numeric_collection_type_table.type_array)
								or else conforms_to_one_of (type_id, Other_collection_type_table.type_array)
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
					if String_types.has (type_id) or else
						conforms_to_one_of (type_id, << Boolean_ref_type, Date_time_type, Storable_type >>)
					then
						Result := True
					elseif field_conforms_to (type_id, Tuple_type) then
						Result := tuple_items_are_expanded_or_string_types (type_of_type (type_id))
					end
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
					Result := String_types.has (type_id)
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
					Result := conforms_to_one_of (type_id, String_convertable_type_table.type_array)
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

	tuple_items_are_expanded_or_string_types (type: TYPE [ANY]): BOOLEAN
		local
			i, count: INTEGER_32; member_type: TYPE [ANY]
		do
			Result := True
			count := type.generic_parameter_count
			from i := 1 until not Result or else i > count loop
				member_type := type.generic_parameter_type (i)
				if not member_type.is_expanded then
					Result := String_types.has (member_type.type_id)
				end
				i := i + 1
			end
		end

end
