note
	description: "Routines for classes conforming to [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-18 17:04:31 GMT (Sunday 18th December 2022)"
	revision: "5"

deferred class
	EL_READABLE_STRING_GENERAL_ROUTINES

inherit
	EL_MODULE_CONVERT_STRING

feature -- Measurement

	occurrences (text, search_string: READABLE_STRING_GENERAL): INTEGER
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string (text, search_string, 0)
				Result := intervals.count
			end
		end

feature -- Status query

	is_convertible (s: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): BOOLEAN
		-- `True' if `str' is convertible to type `basic_type'
		do
			Result := Convert_string.is_convertible (s, basic_type)
		end

feature -- Conversion

	to_type (str: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `basic_type'
		do
			Result := Convert_string.to_type (str, basic_type)
		end

feature -- Basic operations

	search_interval_at_nth (text, search_string: READABLE_STRING_GENERAL; n: INTEGER): INTEGER_INTERVAL
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string (text, search_string, 0)
				from intervals.start until intervals.after or intervals.index > n loop
					intervals.forth
				end
				Result := intervals.item_interval
			else
				create Result.make (0, 0)
			end
		end

	write_utf_8 (s: READABLE_STRING_GENERAL; writeable: EL_WRITABLE)
		local
			i: INTEGER; c: EL_CHARACTER_32_ROUTINES
		do
			from i := 1 until i > s.count loop
				c.write_utf_8 (s [i], writeable)
				i := i + 1
			end
		end

feature -- Measurement

	maximum_count (strings: ITERABLE [READABLE_STRING_GENERAL]): INTEGER
			--
		do
			across strings as str loop
				if str.item.count > Result then
					Result := str.item.count
				end
			end
		end

feature {NONE} -- Constants

	Shared_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end
end