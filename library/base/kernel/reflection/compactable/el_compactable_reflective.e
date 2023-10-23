note
	description: "Object that can be represented as a [$source NATURAL_64] number"
	notes: "[
		Using a compact date as an example the table manifest string must be formatted as follows:

			day:
				1 .. 8
			month:
				9 .. 16
			year:
				17 .. 32
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-23 15:37:25 GMT (Monday 23rd October 2023)"
	revision: "1"

deferred class
	EL_COMPACTABLE_REFLECTIVE

inherit
	EL_REFLECTIVE
		rename
			field_included as is_expanded_field,
			foreign_naming as eiffel_naming
		export
			{EL_REFLECTED_FIELD_BIT_MASKS} field_table
		end

feature {NONE} -- Initialization

	make_by_compact (value: NATURAL_64)
		do
			set_from_compact (value)
		end

feature -- Access

	compact_value: NATURAL_64
		do
			Result := field_masks.compact_value (Current)
		end

feature -- Element change

	set_from_compact (value: NATURAL_64)
		do
			field_masks.set_from_compact (Current, value)
		end

feature {NONE} -- Deferred

	field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		-- implement as once function with manifest string
		deferred
		end

end