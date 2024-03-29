note
	description: "Multi-bit set and get routines for integer types conforming to ${NUMERIC}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_INTEGER_BIT_ROUTINES

inherit
	EL_NUMERIC_BIT_ROUTINES
		redefine
			inserted, isolated
		end

feature -- Access

	inserted (combined_values, mask, value: like one): like one
		-- `combined_values' with `value' inserted at the `mask' position
		require else
			positive_arguments: (<< combined_values, mask, value >>).for_all (agent is_positive)
		deferred
		end

	isolated (combined_values, mask: like one): like one
		-- value isolated from `combined_values' by mask
		require else
			positive_arguments: (<< combined_values, mask >>).for_all (agent is_positive)
		deferred
		end

feature -- Contract Support

	is_positive (v: like one): BOOLEAN
		deferred
		end

end