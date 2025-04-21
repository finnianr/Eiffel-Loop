note
	description: "Routines for classes conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:20:09 GMT (Monday 21st April 2025)"
	revision: "39"

deferred class
	EL_READABLE_STRING_GENERAL_ROUTINES_I

inherit
	EL_MODULE_CONVERT_STRING

	EL_STRING_HANDLER

feature -- Factory

	new_template (general: READABLE_STRING_GENERAL): EL_TEMPLATE [STRING_GENERAL]
		do
			inspect string_storage_type (general)
				when '1' then
					if attached {READABLE_STRING_8} general as str_8 then
						create {EL_TEMPLATE [STRING_8]} Result.make (str_8)
					end

				when 'X' then
					if attached {ZSTRING} general as z_str then
						create {EL_TEMPLATE [ZSTRING]} Result.make (z_str)
					end
			else
				if attached {READABLE_STRING_32} general as str_32 then
					create {EL_TEMPLATE [STRING_32]} Result.make (str_32)
				end
			end
		end


feature -- Measurement

	character_count (list: ITERABLE [READABLE_STRING_GENERAL]; separator_count: INTEGER): INTEGER
		do
			across list as ln loop
				if Result > 0 then
					Result := Result + separator_count
				end
				Result := Result + ln.item.count
			end
		end

	maximum_count (strings: ITERABLE [READABLE_STRING_GENERAL]): INTEGER
			--
		do
			across strings as str loop
				if str.item.count > Result then
					Result := str.item.count
				end
			end
		end

	occurrences (text, search_string: READABLE_STRING_GENERAL): INTEGER
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string_general (text, search_string, 0)
				Result := intervals.count
			end
		end

feature -- Conversion

	to_type (str: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `basic_type'
		do
			Result := Convert_string.to_type (str, basic_type)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if conforms_to_zstring (general) and then attached {ZSTRING} general as z_str then
				Result := z_str.to_general -- Result can be either `STRING_8' or `STRING_32'
			else
				Result := general
			end
		ensure
			not_zstring: not attached {EL_READABLE_ZSTRING} Result
		end

feature -- Basic operations

	search_interval_at_nth (text, search_string: READABLE_STRING_GENERAL; n: INTEGER): INTEGER_INTERVAL
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string_general (text, search_string, 0)
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

feature {NONE} -- Constants

	Shared_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end
end