note
	description: "[
		Edit strings by applying an editing procedure to all occurrences of substrings
		that begin and end with a pair of delimiters.
		
		See `delete_interior' for an example of an editing procedure
	]"
	descendants: "[
			EL_STRING_EDITOR [S -> ${STRING_GENERAL} create make end]*
				${EL_ZSTRING_EDITOR}
				${EL_STRING_8_EDITOR}
				${EL_STRING_32_EDITOR}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "13"

deferred class
	EL_STRING_EDITOR [S -> STRING_GENERAL create make end]

feature {NONE} -- Initialization

	make (a_target: S)
			--
		do
			target := a_target
		end

	make_empty
		do
			create target.make (0)
		end

feature -- Access

	target: S
		-- target text for editing

feature -- Basic operations

	for_each (a_left_delimiter, a_right_delimiter: READABLE_STRING_GENERAL; edit: PROCEDURE [INTEGER, INTEGER, S])
		-- for each occurrence of section delimited by `a_left_delimiter' and `a_right_delimiter'
		-- apply an editing procedure `edit' on the delimited section (including delimiters) with
		-- the interior substring defined by `start_index' and `end_index'
		-- See `delete_interior' as an example
		local
			left_delimiter, right_delimiter, section, output, l_target: S
			end_index, left_index, right_index: INTEGER; done: BOOLEAN
		do
			l_target := target
			create section.make (80)
			create output.make (l_target.count)
			left_delimiter := new_string (a_left_delimiter); right_delimiter := new_string (a_right_delimiter)
			from until done loop
				left_index := l_target.substring_index (left_delimiter, end_index + 1)
				if left_index > 0 then
					right_index := l_target.substring_index (right_delimiter, left_index + left_delimiter.count)
					if right_index > 0 then
						output.append_substring (l_target, end_index + 1, left_index - 1)
						end_index := right_index + right_delimiter.count - 1
						wipe_out (section)
						section.append_substring (l_target, left_index, end_index)
						edit (left_delimiter.count + 1, section.count - right_delimiter.count, section)
						output.append (section)
					else
						done := True
					end
				else
					done := True
				end
			end
			if end_index > 0 then
				output.append_substring (l_target, end_index + 1, l_target.count)
				modify_target (output)
			end
		end

	for_each_balanced (
		left_bracket, right_bracket: CHARACTER_32; leading: READABLE_STRING_GENERAL
		edit: PROCEDURE [INTEGER, INTEGER, S]
	)
		-- apply an editing procedure `edit' for each substring section that has
		-- a balanced number of occurrences of `left_bracket' and `right_bracket'
		-- and an occurrence of `leading' string immediately after the first `left_bracket'
		require
			valid_leading: not (leading.has (left_bracket) or leading.has (right_bracket))
		local
			section, output, l_target: S; left_string: detachable S
			end_index, left_index, right_index, start_index, right_bracket_count: INTEGER
			done: BOOLEAN
		do
			l_target := target
			create section.make (80)
			create output.make (l_target.count)
			if leading.count > 0 then
				create left_string.make (leading.count + 1)
				append_character (left_string, left_bracket)
				left_string.append (leading)
			end
			from until done loop
				if attached left_string as left then
					left_index := l_target.substring_index (left, end_index + 1)
					start_index := left_index + left_string.count
				else
					left_index := l_target.index_of (left_bracket, end_index + 1)
					start_index := left_index + 1
				end
				if left_index > 0 then
					right_index := l_target.index_of (right_bracket, start_index)
					if right_index > 0 then
						from
							right_bracket_count := 1
						until
							-- number of left and right brackets balance
							done or else
								occurrences (l_target, left_bracket, left_index, right_index) = right_bracket_count
						loop
							start_index := right_index + 1
							right_index := l_target.index_of (right_bracket, start_index)
							if right_index > 0 then
								right_bracket_count := right_bracket_count + 1
							else
								done := True
							end
						end
						if not done then
							output.append_substring (l_target, end_index + 1, left_index - 1)
							end_index := right_index
							wipe_out (section)
							section.append_substring (l_target, left_index, end_index)
							if attached left_string as left then
								edit (left_string.count + 1, section.count - 1, section)
							else
								edit (2, section.count - 1, section)
							end
							output.append (section)
						end
					else
						done := True
					end
				else
					done := True
				end
			end
			if end_index > 0 then
				output.append_substring (l_target, end_index + 1, l_target.count)
				modify_target (output)
			end
		end

feature -- Element change

	set_target (a_target: like target)
		do
			target := a_target
		end

feature {NONE} -- Edit example

	delete_interior (start_index, end_index: INTEGER; substring: S)
		-- delete the substring between the delimiting strings of  `substring'
		-- `start_index' and `end_index' defines the interior section.
		do
--			NOTE: this is for documentation purposes only
--			substring.remove_substring (start_index, end_index)
		end

feature {STRING_HANDLER} -- Implementation

	append_character (string: S; c: CHARACTER_32)
		do
			string.append_code (c.natural_32_code)
		end

	modify_target (str: S)
		deferred
		end

	new_string (general: READABLE_STRING_GENERAL): S
		do
			if attached {S} general as str then
				Result := str
			else
				create Result.make (general.count)
				Result.append (general)
			end
		end

	occurrences (str: S; c: CHARACTER_32; start_index, end_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				if str [i] = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	wipe_out (str: S)
		deferred
		end

end