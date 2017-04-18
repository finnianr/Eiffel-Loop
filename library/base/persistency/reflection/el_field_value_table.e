note
	description: "Summary description for {EL_FIELD_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 13:44:38 GMT (Tuesday 24th January 2017)"
	revision: "1"

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

feature {EL_PERSISTENCE_ROUTINES} -- Access

	value_type: TYPE [G]

	value_type_id: INTEGER
		deferred
		end

feature -- Element change

	set_condition (a_condition: like condition)
		do
			condition := a_condition
		end

feature {EL_PERSISTENCE_ROUTINES} -- Element change

	set_conditional_value (key: STRING; new: like item)
		do
			if condition /= default_condition implies condition (new) then
				extend (new, key)
			end
		end

	set_value (key: STRING; object: REFLECTED_REFERENCE_OBJECT; field_index: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	default_condition: like condition

feature {NONE} -- Internal attributes

	condition: PREDICATE [ANY, TUPLE [G]]
end
