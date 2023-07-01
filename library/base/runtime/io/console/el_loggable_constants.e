note
	description: "Shared indexable types and console color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-30 8:11:26 GMT (Friday 30th June 2023)"
	revision: "5"

deferred class
	EL_LOGGABLE_CONSTANTS

inherit
	EL_ANY_SHARED

feature -- Contract Support

	valid_colors: like Color.Valid_colors
		do
			Result := Color.Valid_colors
		end

	is_indexable (object: ANY): BOOLEAN
		-- `True' if `object' has an integer index value associated with it
		local
			type_id: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (object)
			Result := across Indexable_types as type some
				{ISE_RUNTIME}.type_conforms_to (type_id, type.item.type_id)
			end
		end

feature {NONE} -- Implementation

	Color: EL_CONSOLE_COLORS
		once ("PROCESS")
			create Result
		end

	Indexable_types: ARRAY [TYPE [ANY]]
		-- types that maybe converted to an integer index
		once ("PROCESS")
			Result := <<
				{INDEXABLE_ITERATION_CURSOR [ANY]}, {LINEAR [ANY]}, {INTEGER_32_REF}, {NATURAL_32_REF}
			>>
		end

end