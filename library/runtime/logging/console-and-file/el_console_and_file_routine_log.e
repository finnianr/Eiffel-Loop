note
	description: "[
		Logs routines which are set to have logging enabled in the global configuration
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-10 11:21:34 GMT (Monday 10th February 2020)"
	revision: "5"

class
	EL_CONSOLE_AND_FILE_ROUTINE_LOG

inherit
	EL_ROUTINE_LOG
		redefine
			traced_routine_call_stack, output, exit, pause_for_enter_key, enter_with_args
		end

	EL_MODULE_LOG_MANAGER
		rename
			current_thread_log_file as output
		end

create
	make

feature {NONE} -- Initialization

	make (a_traced_routine_call_stack: like traced_routine_call_stack)
		do
			traced_routine_call_stack := a_traced_routine_call_stack
		end

feature -- Basic operations

	enter_with_args  (routine_name: STRING; arg_objects: TUPLE)
			--
		do
			out_put_enter_heading (arg_objects)
		end

	exit
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.tab_left
			l_out.put_new_line
			l_out.set_text_red
			l_out.put_keyword (once "end")

			l_out.set_text_light_green
			l_out.put_string (once " -- "); l_out.put_string (current_routine.class_name)
			l_out.set_text_default

			l_out.tab_left
			l_out.put_new_line

			l_out.flush
		end

	pause_for_enter_key
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_string (once "<Press enter to leave routine>")
			l_out.flush
			io.read_line
		end

feature {NONE} -- Implementation

	out_put_enter_heading (arg_objects: TUPLE)
			--
		local
			i: INTEGER
			l_out: like output
		do
			l_out := output

			l_out.put_new_line
			l_out.put_classname (current_routine.class_name)
			l_out.put_character ('.')
			l_out.put_string (current_routine.name)

			if not arg_objects.is_empty then
				l_out.put_string_general (once " (")
				from i := 1 until i > arg_objects.count loop
					out_put_argument (i, arg_objects.count, arg_objects.item (i))
					i := i + 1
				end
				if arg_objects.count > 1 then
					l_out.put_new_line
				end
				l_out.put_character (')')
			end
			l_out.tab_right; l_out.put_new_line
			l_out.put_keyword (once "doing")
			l_out.tab_right; l_out.put_new_line

			l_out.flush
		end

	out_put_argument (arg_pos, arg_count: INTEGER; arg_object: ANY)
			--
		local
			l_out: like output; arg_label: STRING
		do
			l_out := output

			if arg_count > 1 then
				l_out.tab_right; l_out.tab_right; l_out.put_new_line

				arg_label := "arg_"
				arg_label.append_integer (arg_pos)
				l_out.put_label (arg_label)
			end
			if attached {NUMERIC} arg_object as numeric_arg then
				l_out.put_string (arg_object.out)

			elseif attached {READABLE_STRING_GENERAL} arg_object as general then
				l_out.put_quoted_string (general, Double_quote)

			elseif attached {EL_PATH} arg_object as path_arg then
				l_out.put_quoted_string (path_arg.to_string, Double_quote)

			elseif attached {EL_NAMEABLE} arg_object as nameable then
				if nameable.name.has (' ') then
					l_out.put_quoted_string (nameable.name, Double_quote)
				else
					l_out.put_string (nameable.name)
				end

			elseif attached {BOOLEAN_REF} arg_object as bool then
				l_out.put_string (bool.out)

			elseif attached {CHARACTER_8_REF} arg_object as char_8 then
				l_out.put_quoted_string (char_8.out, Single_quote)

			elseif attached {CHARACTER_32_REF} arg_object as char_32 then
				l_out.put_quoted_string (create {STRING_32}.make_filled (char_32.item, 1), Single_quote)
			else
				l_out.set_text_blue
				l_out.put_string (arg_object.generating_type.name)
				l_out.set_text_default
			end
			if arg_count > 1 then
				l_out.tab_left; l_out.tab_left
			end
		end

	traced_routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE_INFO]

end






