note
	description: "[
		Logs routines which are set to have logging enabled in the global configuration
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-03 11:43:52 GMT (Monday 3rd February 2025)"
	revision: "17"

class
	EL_CONSOLE_AND_FILE_ROUTINE_LOG

inherit
	EL_ROUTINE_LOG
		redefine
			clear, output, exit, pause_for_enter_key, enter_with_args, move_cursor_up,
			set_text_color, set_text_color_light
		end

	EL_MODULE_LOG_MANAGER
		rename
			current_thread_log_file as output
		end

create
	make

feature {NONE} -- Initialization

	make (a_call_stack: like routine_call_stack)
		do
			routine_call_stack := a_call_stack
		end

feature -- Status change

	set_text_color (code: INTEGER)
		do
			if attached output as op then
				op.set_text_color (code)
				op.flush
			end
		end

	set_text_color_light (code: INTEGER)
		do
			if attached output as op then
				op.set_text_color_light (code)
				op.flush
			end
		end

feature -- Basic operations

	clear
		-- clear screen		
		do
			if attached output as op then
				op.clear; op.flush
			end
		end

	enter_with_args  (routine_name: STRING; arg_objects: TUPLE)
			--
		do
			out_put_enter_heading (arg_objects)
		end

	exit
			--
		do
			if attached output as op then
				op.tab_left
				op.put_new_line
				op.set_text_color_light (Color.Red)
				op.put_keyword (once "end")

				op.set_text_color_light (Color.Green)
				op.put_string (once " -- "); op.put_string_general (current_routine.type_name)
				op.set_text_color (Color.Default)

				op.tab_left
				op.put_new_line

				op.flush
			end
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		do
			if attached output as op then
				op.move_cursor_up (n)
				op.flush
			end
		end

	pause_for_enter_key
			--
		do
			if attached output as op then
				op.put_string (once "<Press enter to leave routine>")
				op.flush
				io.read_line
			end
		end

feature {NONE} -- Implementation

	out_put_argument (arg_pos, arg_count: INTEGER; arg_object: ANY)
			--
		do
			if attached output as op then
				if arg_count > 1 then
					op.tab_right; op.tab_right; op.put_new_line

					op.put_label (Label_template #$ [arg_pos])
				end
				if attached {NUMERIC} arg_object as numeric_arg then
					op.put_string (arg_object.out)

				elseif attached {READABLE_STRING_GENERAL} arg_object as general then
					op.put_quoted_string (general)

				elseif attached {EL_PATH} arg_object as path_arg then
					op.put_quoted_string (path_arg.to_string)

				elseif attached {EL_NAMEABLE [READABLE_STRING_GENERAL]} arg_object as nameable then
					if nameable.name.has (' ') then
						op.put_quoted_string (nameable.name)
					else
						op.put_string_general (nameable.name)
					end

				elseif attached {BOOLEAN_REF} arg_object as bool then
					op.put_string (bool.out)

				elseif attached {CHARACTER_8_REF} arg_object as char_8 then
					op.put_quoted_character (char_8.item)

				elseif attached {CHARACTER_32_REF} arg_object as char_32 then
					op.put_quoted_character (char_32.item)
				else
					op.set_text_color (Color.Blue)
					op.put_string (arg_object.generating_type.name)
					op.set_text_color (Color.Default)
				end
				if arg_count > 1 then
					op.tab_left; op.tab_left
				end
			end
		end

	out_put_enter_heading (arg_objects: TUPLE)
			--
		local
			i: INTEGER
		do
			if attached output as op then
				op.put_new_line
				op.put_classname (current_routine.type_name)
				op.put_character ('.')
				op.put_string (current_routine.name)

				if not arg_objects.is_empty then
					op.put_string_general (once " (")
					from i := 1 until i > arg_objects.count loop
						out_put_argument (i, arg_objects.count, arg_objects.item (i))
						i := i + 1
					end
					if arg_objects.count > 1 then
						op.put_new_line
					end
					op.put_character (')')
				end
				op.tab_right; op.put_new_line
				op.put_keyword (once "doing")
				op.tab_right; op.put_new_line

				op.flush
			end
		end

feature {NONE} -- Constants

	Label_template: ZSTRING
		once
			Result := "arg_%S"
		end
end