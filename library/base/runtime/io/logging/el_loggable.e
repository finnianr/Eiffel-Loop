note
	description: "Loggable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-03 13:54:09 GMT (Monday 3rd February 2025)"
	revision: "30"

deferred class
	EL_LOGGABLE

inherit
	ANY

	EL_LOGGABLE_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			routine_call_stack := Empty_routine_call_stack
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		deferred
		end

feature -- Type definitions

	NAME_VALUE_PAIR: TUPLE [name: READABLE_STRING_GENERAL; value: ANY]
		once
			create Result
		end

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LIO} -- Basic operations

	clear
		-- clear screen		
		deferred
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		deferred
		end

	restore (previous_stack_count: INTEGER)
			--
		deferred
		end

	set_logged_object (current_logged_object: ANY)
			--
		deferred
		end

	set_timer
			-- Set routine timer to now
		deferred
		end

feature -- Measurement

	call_stack_count: INTEGER
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
			Result := routine_call_stack.count
		end

feature -- Status change

	set_text_color (code: INTEGER)
		require
			valid_code: valid_colors.has (code)
		deferred
		end

	set_text_color_light (code: INTEGER)
		require
			valid_code: valid_colors.has (code)
		deferred
		end

	tab_left
			--
		deferred
		end

	tab_right
			--
		deferred
		end

feature -- Output

	enter (routine_name: STRING )
			-- Enter start of routine
		deferred
		end

	enter_no_header (routine_name: STRING)
			--
		deferred
		end

	enter_with_args (routine_name: STRING; arg_objects: TUPLE)
			--
		deferred
		end

	exit
		deferred
		end

	exit_no_trailer
		deferred
		end

	put_boolean (b: BOOLEAN)
			--
		deferred
		end

	put_character (c: CHARACTER)
			--
		deferred
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		deferred
		end

	put_field_list (max_line_count: INTEGER; list: ARRAY [like NAME_VALUE_PAIR])
		deferred
		end

	put_new_line
			--
		deferred
		end

	put_new_line_x2
		deferred
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
		-- output `a_path' substituting '%S' character for word "file" or "directory"
		deferred
		end

	put_spaces (n: INTEGER)
			--
		deferred
		end

feature -- String output

	put_classname (a_name: READABLE_STRING_8)
		deferred
		end

	put_curtailed_string_field (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
		-- put curtailed version of `field_value' to log file edited to fit into `max_length', with ellipsis dots inserted
		-- at 80% of `max_length'
		deferred
		end

	put_words (words: FINITE [READABLE_STRING_GENERAL]; max_line_count: INTEGER)
		-- display words grouped on each line by first character in alphabetical order
		local
			first_character: CHARACTER_32; line_count: INTEGER
			word_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			if words.count > 0 then
				create word_list.make_from (words)
				word_list.sort (True)
				if word_list.first.count > 0 then
					first_character := word_list.first [1]
					across word_list as list loop
						if attached list.item as str then
							if list.cursor_index > 1 then
								if str.count > 0 and then first_character /= str [1] then
									put_new_line
									first_character := str [1]
									line_count := 0

								elseif line_count + str.count > max_line_count then
									put_new_line
									line_count := 0
								else
									set_text_color_light (Color.Purple)
									put_string (Semicolon_space)
									set_text_color (Color.Default)
									line_count := line_count + 2
								end
							end
							put_string (str)
							line_count := line_count + str.count
						end
					end
					put_new_line
				end
			end
		end

	put_index_labeled_string (indexable: ANY; label_or_format: detachable READABLE_STRING_GENERAL; str: READABLE_STRING_GENERAL)
		-- output integer index value associated with `indexable' object that may conform to one of:
		--		`LINEAR', `INDEXABLE_ITERATION_CURSOR', `INTEGER_32_REF', `NATURAL_32_REF'

		-- An optional formatting `label_or_format' that may be interpreted in the following ways:

		--		1. A template if it contains a substitution placeholder '%S' for the `indexable' value (Eg. "i_th [%S]")
		--		2. A padding format for the `indexable' value if all the characters are equal to '9'
		--		3. Or else a prefix before the `indexable' value

		require
			is_indexable: is_indexable (indexable)
		deferred
		end

	put_keyword (keyword: READABLE_STRING_8)
		deferred
		end

	put_labeled_lines (label: READABLE_STRING_GENERAL; lines: ITERABLE [READABLE_STRING_GENERAL])
			--
		deferred
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_labeled_substitution (label, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		deferred
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		deferred
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
			-- Substitute inserts into template at the '%S' markers
			-- If the tempate has a colon, then apply color highlighting as per `put_labeled_string'
		deferred
		end

feature -- Numeric output

	put_double (d: DOUBLE; a_format: detachable STRING)
			--
		deferred
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE; a_format: detachable STRING)
			--
		deferred
		end

	put_integer (i: INTEGER)
			--
		deferred
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		deferred
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		deferred
		end

	put_natural (n: NATURAL)
			--
		deferred
		end

	put_natural_field (label: READABLE_STRING_GENERAL; field_value: NATURAL)
			--
		deferred
		end

	put_real (r: REAL; a_format: detachable STRING)
			--
		deferred
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL; a_format: detachable STRING)
			--
		deferred
		end

feature -- Input

	pause_for_enter_key
		deferred
		end

feature {NONE} -- Implementation

	current_routine: EL_LOGGED_ROUTINE
			--
		require
			valid_logged_routine_call_stack: not routine_call_stack.is_empty
		do
			Result := routine_call_stack.item
		end

	routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE]
		-- traced routine call stack

feature {NONE} -- Constants

	Empty_routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE]
		once
			create Result.make (0)
		end

end