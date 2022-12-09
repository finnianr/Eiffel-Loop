note
	description: "[
		Enumeration of type ids by correspondence of fields names to type names.
		Example: [$source EL_CLASS_TYPE_ID_ENUM]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "10"

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
			i, count: INTEGER
		do
			create this.make (Current)
			count := this.field_count
			from i := 1 until i > count loop
				if this.field_type (i) = Integer_32_type then
					type_id := Eiffel.dynamic_type_from_string (this.field_name (i).as_upper)
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
end