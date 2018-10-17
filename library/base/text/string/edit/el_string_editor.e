note
	description: "[
		Edit strings by applying an editing procedure to all occurrences of substrings
		that begin and end with a pair of delimiters.
		
		See `delete_interior' for an example of an editing procedure
	]"
	descendants: "[
			EL_STRING_EDITOR*
				[$source EL_ZSTRING_EDITOR]
				[$source EL_STRING_8_EDITOR]
				[$source EL_STRING_32_EDITOR]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-15 9:35:04 GMT (Monday 15th October 2018)"
	revision: "6"

deferred class
	EL_STRING_EDITOR [S -> STRING_GENERAL create make end]

inherit
	STRING_HANDLER

feature {NONE} -- Initialization

	make (a_target: S)
			--
		do
			target := a_target
		end

feature -- Access

	target: S
		-- target text for editing

feature -- Basic operations

	for_each (a_left_delimiter, a_right_delimiter: READABLE_STRING_GENERAL; edit: PROCEDURE [INTEGER, INTEGER, S])
		-- for each occurrence of section delimited by `a_left_delimiter' and `a_right_delimiter'
		-- apply an editing procedure `edit' on the delimited section (including delimiters)
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
			output.append_substring (l_target, end_index + 1, l_target.count)
			set_target (output)
		end

feature {NONE} -- Edit example

	delete_interior (start_index, end_index: INTEGER; substring: S)
		-- delete the substring between the delimiting strings of  `substring'
		-- `start_index' and `end_index' defines the interior section.
		do
--			NOTE: this is for documentation purposes only
--			substring.remove_substring (start_index, end_index)
		end

feature {NONE} -- Implementation

	set_target (str: S)
		deferred
		end

	wipe_out (str: S)
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

end
