note
	description: "Table of field value"
	notes: "[
		The original intention was to use this class with objects implementing class [$source EL_REFLECTIVE]
		The table that can be filled with fields values using the `fill_field_value_table' procedure.
		The type of fields that can be filled is specified by generic paramter `G'. 
		An optional condition predicated can be set that filters the table content according to the value
		of the field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 16:16:05 GMT (Sunday 16th July 2023)"
	revision: "7"

deferred class
	EL_FIELD_VALUE_TABLE [G]

inherit
	EL_STRING_8_TABLE [G]
		rename
			make as make_from_array,
			make_equal as make
		redefine
			make
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			value_type := {G}
			value_type_id := value_type.type_id
			default_condition := agent (v: G): BOOLEAN do end
			condition := default_condition
		end

feature -- Access

	value_type: TYPE [G]

	value_type_id: INTEGER

feature -- Element change

	set_condition (a_condition: like condition)
		do
			condition := a_condition
		end

feature -- Element change

	set_conditional_value (key: READABLE_STRING_8; new: like item)
		do
			if condition /= default_condition implies condition (new) then
				extend (new, key)
			end
		end

	set_value (key: READABLE_STRING_8; value: ANY)
		deferred
		end

feature {NONE} -- Implementation

	default_condition: like condition

feature {NONE} -- Internal attributes

	condition: PREDICATE [G]
end