note
	description: "[
		Enumeration of type identifiers by correspondence of fields names to type names.
		Example: ${EL_CLASS_TYPE_ID_ENUM}
	]"
	notes: "[
		**Double Underscores**

		A double underscore indicates a type with a generic parameter. For example:
		
			ARRAYED_LIST__ANY: INTEGER
		
		will be assigned the type id for:
		
			ARRAYED_LIST [ANY]
			
		Only one parameter can be interpreted.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 13:51:14 GMT (Monday 15th April 2024)"
	revision: "12"

class
	EL_TYPE_ID_ENUMERATION

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	make
		local
			type_id: INTEGER; this: REFLECTED_REFERENCE_OBJECT
			i, count, index: INTEGER; type_name: STRING
		do
			create this.make (Current)
			count := this.field_count
			from i := 1 until i > count loop
				if this.field_type (i) = Integer_32_type then
					type_name := this.field_name (i).as_upper
				-- Check for generic parameter
					index := type_name.substring_index (Double_underscore, 1)
					if index > 0 then
					-- add generic parameter
						type_name.replace_substring (Left_square_bracket, index, index + 1)
						type_name.append_character (']')
					end
					type_id := Eiffel.dynamic_type_from_string (type_name)
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
			this: REFLECTED_REFERENCE_OBJECT
			i, count: INTEGER
		do
			create this.make (Current)
			count := this.field_count
			Result := True
			from i := 1 until not Result or else i > count loop
				Result := this.field_type (i) = Integer_32_type implies this.integer_32_field (i) >= 0
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Double_underscore: STRING = "__"

	Left_square_bracket: STRING = " ["
end