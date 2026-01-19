note
	description: "${ROUTINE_FEATURE} that is an EQA test routine starting with `test_' prefix"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 10:14:01 GMT (Wednesday 7th May 2025)"
	revision: "1"

class
	TEST_PROCEDURE

inherit
	ROUTINE_FEATURE
		rename
			make as make_routine
		redefine
			expand_shorthand
		end

create
	make

feature {NONE} -- Initialization

	make (a_class_name, first_line: ZSTRING)
		do
			make_routine (first_line)
			class_name := a_class_name
		end

feature -- Access

	class_name: ZSTRING

	test_name: ZSTRING
		do
			Result := name.substring_end (6)
		end

feature -- Element change

	expand_shorthand
		-- insert or replace comment with class_name and test name for cut-and-paste
		-- into Execution parameters after -autotest -test_set <insert-here>
		local
			line, new_comment: ZSTRING; eiffel: EL_EIFFEL_SOURCE_ROUTINES
			replace, insert: BOOLEAN
		do
			if lines.count > 1 then
				line := lines [2]
				if eiffel.is_comment (line) and then attached eiffel.comment_text (line) as comment then
					if comment.occurrences ('.') = 1 and then attached comment.split_list ('.') as parts
						and then parts.first.is_code_identifier and then parts.last.is_code_identifier
					then
						replace := parts.first /~ class_name or parts.last /~ test_name
					else
						insert := True
					end
				else
					insert := True
				end
				if insert or replace then
					new_comment := Comment_template #$ [class_name, test_name]
					if insert then
						lines.insert (new_comment, 2)
					else
						lines [2] := new_comment
					end
				end
			end
			Precursor
		end

feature {NONE} -- Constants

	Comment_template: ZSTRING
		once
			Result := "%T%T-- %S.%S"
		end
end