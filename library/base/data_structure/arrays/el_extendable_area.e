note
	description: "[
		Abstraction with extendible area of type ${SPECIAL [G]} area. 
		It can be implemented with the aid of class ${EL_EXTENDABLE_AREA_IMP [G]}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-07 16:51:50 GMT (Friday 7th February 2025)"
	revision: "12"

deferred class
	EL_EXTENDABLE_AREA [G]

feature -- Status query

	not_empty: BOOLEAN
		do
			Result := area.count > 0
		end

feature -- Measurement

	area_count: INTEGER
		do
			Result := area.count
		end

feature {NONE} -- Implementation

	big_enough (a_area: like area; additional_count: INTEGER): like area
		local
			minimal: INTEGER
		do
			if a_area.count + additional_count > a_area.capacity then
				minimal := additional_count.max (Minimal_increase)
				-- changing from `aliased_resized_area' to `resized_area' fixed the bug in My Ching
				-- where strings where corrupted in test `ENCRYPTED_128_BIT_READING_LIST_TEST_SET'
				Result := a_area.resized_area (a_area.count + (a_area.capacity // 2).max (minimal))
			else
				Result := a_area
			end
		end

	set_if_changed (current_area, a_area: like area)
		do
			if current_area /= a_area then
				set_area (a_area)
			end
		end

feature {NONE} -- Deferred

	area: SPECIAL [G]
		deferred
		end

	new_filled_area (item: G; n: INTEGER): SPECIAL [G]
		deferred
		end

	set_area (a_area: like area)
		deferred
		end

feature {NONE} -- Constants

	Minimal_increase: INTEGER = 5
		-- Minimal number of additional items

note
	descendants: "[
			EL_EXTENDABLE_AREA* [G]
				${EL_SUBSTRING_32_BUFFER}
				${EL_COMPACT_SUBSTRINGS_32_BASE*}
					${EL_COMPACT_SUBSTRINGS_32_I*}
						${EL_COMPACT_SUBSTRINGS_32}
							${EL_COMPACT_SUBSTRINGS_32_BUFFER}
						${EL_ZSTRING_BASE*}
	]"
end