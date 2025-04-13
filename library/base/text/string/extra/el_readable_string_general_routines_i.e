note
	description: "Routines for classes conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-13 7:45:58 GMT (Sunday 13th April 2025)"
	revision: "35"

deferred class
	EL_READABLE_STRING_GENERAL_ROUTINES_I

inherit
	EL_MODULE_CONVERT_STRING

	EL_SHARED_FILLED_STRING_TABLES

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

	start_plus_end_assignment_indices (line: READABLE_STRING_GENERAL; p_end_index: TYPED_POINTER [INTEGER]): INTEGER
		local
			p: EL_POINTER_ROUTINES; assign_index, end_index: INTEGER
		do
			assign_index := line.substring_index (assign_symbol, 1)

			if assign_index > 0 and line.valid_index (assign_index - 1) then
				if line [assign_index - 1] = ' ' then
					end_index := assign_index - 2
				else
					end_index := assign_index - 1
				end
			end
			if assign_index > 0 and line.valid_index (assign_index + 2) then
				if line [assign_index + 2] = ' ' then
					Result := assign_index + 3
				else
					Result := assign_index + 2
				end
			end
			p.put_integer_32 (end_index, p_end_index)
		end

feature -- Status query

	is_character (str: READABLE_STRING_GENERAL; uc: CHARACTER_32): BOOLEAN
		-- `True' if `str.same_string (uc.out)' is true
		do
			Result := str.count = 1 and then str [1] = uc
		ensure
			definition: Result implies str.occurrences (uc) = 1
		end

	valid_assignments (a_manifest: READABLE_STRING_GENERAL): BOOLEAN
		local
			start_index, end_index: INTEGER
		do
			Result := True
			across a_manifest.split ('%N') as list until not Result loop
				if attached list.item as line then
					start_index := start_plus_end_assignment_indices (line, $end_index)
					Result := end_index >= 1 and start_index <= line.count
				end
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

	Assign_symbol: STRING = ":="

	Shared_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end
end