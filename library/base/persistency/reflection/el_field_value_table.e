note
	description: "[
		Table that can be filled with fields values from an object implementing class [$source EL_REFLECTIVE]
		using the `fill_field_value_table' procedure. The type of fields that can be filled is specified by 
		generic paramter `G'. An optional condition predicated can be set that filters the table content
		according to the value of the field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-04 12:08:35 GMT (Wednesday 4th April 2018)"
	revision: "4"

deferred class
	EL_FIELD_VALUE_TABLE [G]

inherit
	HASH_TABLE [G, STRING]
		rename
			make as make_with_count,
			make_equal as make
		redefine
			make
		end

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal, copy
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			value_type := {G}
			default_condition := agent (v: G): BOOLEAN do end
			condition := default_condition
		end

feature {EL_REFLECTIVE} -- Access

	value_type: TYPE [G]

	value_type_id: INTEGER
		deferred
		end

feature -- Element change

	set_condition (a_condition: like condition)
		do
			condition := a_condition
		end

feature {EL_REFLECTIVE} -- Element change

	set_conditional_value (key: STRING; new: like item)
		do
			if condition /= default_condition implies condition (new) then
				extend (new, key)
			end
		end

	set_value (key: STRING; value: ANY)
		deferred
		end

feature {NONE} -- Implementation

	default_condition: like condition

feature {NONE} -- Internal attributes

	condition: PREDICATE [G]
end
