note
	description: "[
		Enumeration of type identifiers by correspondence of fields names to type names.
		Example: ${EL_CLASS_TYPE_ID_ENUM}
	]"
	notes: "[
		**Double Underscores**

		A double underscore indicates a type with a generic parameter. For example:
		
			HASH_TABLE__ANY__HASHABLE: INTEGER
		
		will be assigned the type id for:
		
			HASH_TABLE [ANY, HASHABLE]
			
		Only one parameter can be interpreted.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 8:50:17 GMT (Friday 28th March 2025)"
	revision: "16"

class
	EL_TYPE_ID_ENUMERATION

inherit
	REFLECTOR
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		local
			type_id: INTEGER; this: REFLECTED_REFERENCE_OBJECT
			i, count: INTEGER; type_name: STRING
		do
			create this.make (Current)
			count := this.field_count
			from i := 1 until i > count loop
				if this.field_type (i) = Integer_32_type then
					type_name := this.field_name (i).as_upper
					if type_name.has_substring (Double_underscore) then
					-- add generic parameter
						type_name := generic_type_name (type_name)
					end
					type_id := dynamic_type_from_string (type_name)
					if type_id >= 0 then
						this.set_integer_32_field (i, type_id)
					else
						check
							valid_type_name: False
						end
					end
				end
				i := i + 1
			end
		ensure
			all_types_set: all_types_set
		end

feature {NONE} -- Contract Support

	all_types_set: BOOLEAN
		local
			this: REFLECTED_REFERENCE_OBJECT; i, count: INTEGER
		do
			create this.make (Current)
			count := this.field_count
			Result := True
			from i := 1 until not Result or else i > count loop
				Result := this.field_type (i) = Integer_32_type implies this.integer_32_field (i) >= 0
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	generic_type_name (type_name: STRING): STRING
		local
			part_list: EL_SPLIT_STRING_8_LIST
		do
			create Result.make (type_name.count + 1)
			create part_list.make_by_string (type_name, Double_underscore)
			across part_list as list loop
				if list.cursor_index = 2 then
					Result.append_character (' ')
					Result.append_character ('[')

				elseif list.cursor_index > 2 then
					Result.append_character (',')
					Result.append_character (' ')
				end
				Result.append (list.item)
				if list.is_last then
					Result.append_character (']')
				end
			end
		ensure
			area_allocation_correct: Result.count = Result.capacity
		end

feature {NONE} -- Constants

	Double_underscore: STRING = "__"

	Left_square_bracket: STRING = " ["
end