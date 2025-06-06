note
	description: "Field that conforms to type ${EL_REFLECTED_REFERENCE [EL_MAKEABLE_FROM_STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:24:13 GMT (Monday 28th April 2025)"
	revision: "23"

deferred class
	EL_REFLECTED_MAKEABLE_FROM_STRING [MAKEABLE -> EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]

inherit
	EL_REFLECTED_REFERENCE [MAKEABLE]
		undefine
			set_from_readable, write
		redefine
			is_abstract, is_initializeable, group_type, post_make, reset,
			set_from_string, set_from_readable, to_string
		end

	EL_REFLECTION_CONSTANTS

feature {EL_CLASS_META_DATA} -- Initialization

	post_make
		-- initialization after types have been set
		do
			Precursor
			makeable_from_string_type_id := ({MAKEABLE}).type_id
		end

feature -- Access

	group_type: TYPE [ANY]
		do
			Result := {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}
		end

	to_string (object: ANY): READABLE_STRING_GENERAL
		do
			Result := value (object).to_string
		end

feature -- Basic operations

	reset (object: ANY)
		do
			if attached value (object) as l_value then
				l_value.make_default
			end
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			value (object).make_from_general (string)
		end

feature -- Status query

	is_initializeable: BOOLEAN
		-- `True' when possible to create an initialized instance of the field
		do
			Result := Precursor or else conforms_to_type (makeable_from_string_type_id)
		end

feature {NONE} -- Implementation

	makeable_from_string_type_id: INTEGER

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

end