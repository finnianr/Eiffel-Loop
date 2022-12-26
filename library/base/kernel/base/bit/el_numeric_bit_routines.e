note
	description: "Multi-bit set and get routines for types conforming to [$source NUMERIC]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 16:05:46 GMT (Monday 26th December 2022)"
	revision: "2"

deferred class
	EL_NUMERIC_BIT_ROUTINES

inherit
	PLATFORM
		export
			{NONE} all
		end

feature -- Access

	inserted (combined_values, mask, value: like one): like one
		-- `combined_values' with `value' inserted at the `mask' position
		require
			valid_mask: valid_mask (mask)
			compatible_value: compatible_value (mask, value)
		deferred
		ensure
			value_inserted: isolated (Result, mask) = value
		end

	isolated (combined_values, mask: like one): like one
		-- value isolated from `combined_values' by mask
		require
			valid_mask: valid_mask (mask)
		deferred
		end

feature -- Contract Support

	compatible_value (mask, value: like one): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		deferred
		end

	valid_mask (mask: like one): BOOLEAN
		-- `True' if mask consists of continuous ones
		deferred
		end

feature {NONE} -- Implemenation

	one: NUMERIC
		deferred
		end
end