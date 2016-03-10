note
	description: "[
		Efficient Boyer-Moore Search for Unicode Strings
		See: http://www.codeproject.com/KB/recipes/bmsearch.aspx
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_BOYER_MOORE_SEARCHER_32

inherit
	EL_MODULE_LOG
create
	make

feature {NONE} -- Initialization

	make (pattern: STRING_32)
		require
			pattern_not_empty: not pattern.is_empty
		local
			max_shift, i, new_suffix_pos: INTEGER
			suffix, new_suffix, new_pattern: STRING_32
		do
			create char_shifts.make (17)
			char_shifts.compare_objects

			pattern_count := pattern.count
			max_shift := pattern_count
			from i := 1 until i > pattern_count loop
				char_shifts.put (create {like other_char_shifts}.make (1, pattern_count), pattern [i])
				i := i + 1
			end
			create other_char_shifts.make (1, pattern_count)
			from char_shifts.start until char_shifts.after loop
				char_shifts.item_for_iteration [pattern_count] := max_shift
				char_shifts.forth
			end
			other_char_shifts [pattern_count] := max_shift

			from i := pattern_count until i = 0 loop
				suffix := pattern.substring (i + 1, pattern_count)
				if pattern.starts_with (suffix) then
					max_shift := i
				end
				other_char_shifts [i] := max_shift
				new_pattern := pattern.string
				if suffix.is_empty or else last_index_of (new_pattern, suffix) > 1 then
					from char_shifts.start until char_shifts.after loop
						create new_suffix.make (suffix.count)
						new_suffix.append_character (char_shifts.key_for_iteration)
						new_suffix.append (suffix)
						new_suffix_pos := last_index_of (new_pattern, new_suffix)
						if new_suffix_pos > 0 then
							char_shifts.item_for_iteration [i] := i - new_suffix_pos
						else
							char_shifts.item_for_iteration [i] := max_shift
						end
						if char_shifts.key_for_iteration = pattern [i] then
							char_shifts.item_for_iteration [i] := 0
						end
						char_shifts.forth
					end
				else
					from char_shifts.start until char_shifts.after loop
						char_shifts.item_for_iteration [i] := max_shift
						if char_shifts.key_for_iteration = pattern [i] then
							char_shifts.item_for_iteration [i] := 0
						end
						char_shifts.forth
					end
				end
				i := i - 1
			end
		end

feature -- Access

	index (text: STRING_32; start_index: INTEGER): INTEGER
			-- index of first pattern occurrence in text starting from 'start_index'
			-- Returns 0 if not found
		local
			pos, i, shift: INTEGER
			position_shifted, found: BOOLEAN
		do
--			log.enter ("search")
			from pos := start_index until found or pos > text.count - pattern_count + 1 loop
				position_shifted := False
--				log.put_integer_field ("pos", pos)
--				log.put_new_line
				from i := pattern_count until position_shifted or i = 0 loop
					char_shifts.search (text [pos + i - 1])
					if char_shifts.found then
						shift := char_shifts.found_item [i]
						if shift /= 0 then
							pos := pos + shift
							position_shifted := True

						elseif i = 1 then
							Result := pos
							found := True
						end
					else
						pos := pos + other_char_shifts [i]
						position_shifted := True
					end
					i := i - 1
				end
			end
--			log.exit
		end

feature -- Basic operations

	log_print
		do
			from char_shifts.start until char_shifts.after loop
				log.put_character (char_shifts.key_for_iteration.to_character_8)
				log.put_string (": ")
				char_shifts.item_for_iteration.do_all_with_index (agent log_shifts)
				log.put_new_line
				char_shifts.forth
			end
			log.put_string ("*: ")
			other_char_shifts.do_all_with_index (agent log_shifts)
			log.put_new_line
		end

	log_shifts (shift, pos: INTEGER)
		do
			if pos > 1 then
				log.put_string (", ")
			end
			log.put_integer (shift)
		end

feature {NONE} -- Implementation

	last_index_of (str, pattern: STRING_32): INTEGER
			-- last pos of pattern in str
		local
			pos: INTEGER
			match_found: BOOLEAN
		do
			if pattern.count <= str.count then
				from pos := str.count - pattern.count + 1 until match_found or pos = 0 loop
					if pattern ~ str.substring (pos, pos + pattern.count - 1) then
						match_found := True
					else
						pos := pos - 1
					end
				end
				Result := pos
			else
				Result := 0
			end
		end

	char_shifts: HASH_TABLE [like other_char_shifts, CHARACTER_32]

	other_char_shifts: ARRAY [INTEGER]

	pattern_count: INTEGER

end
