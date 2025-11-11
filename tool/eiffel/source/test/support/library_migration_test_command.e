note
	description: "${LIBRARY_MIGRATION_COMMAND} with debugging output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-10 13:07:53 GMT (Monday 10th November 2025)"
	revision: "4"

class
	LIBRARY_MIGRATION_TEST_COMMAND

inherit
	LIBRARY_MIGRATION_COMMAND
		redefine
			print_iteration, print_class_heading, print_line, prompt_user, print_tab_left
		end

create
	make

feature {NONE} -- Implementation

	print_iteration (i: INTEGER)
		do
			lio.put_integer_field ("ITERATION", i)
			lio.put_new_line
		end

	print_class_heading (name: IMMUTABLE_STRING_8)
		do
			lio.put_labeled_string ("Class", name)
			lio.put_new_line
			lio.tab_right
			lio.put_new_line
		end

	print_line (line: IMMUTABLE_STRING_8)
		do
			lio.put_line (line)
		end

	print_tab_left
		do
			lio.tab_left
			lio.put_new_line
		end

	prompt_user (name_array: ARRAY [IMMUTABLE_STRING_8])
		do
		end

end