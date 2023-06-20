note
	description: "User input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 9:42:19 GMT (Tuesday 20th June 2023)"
	revision: "18"

class
	EL_USER_INPUT

inherit
	EL_ZSTRING_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_MODULE_CONSOLE; EL_MODULE_LIO

feature -- Status query

	approved_action (prompt: READABLE_STRING_GENERAL; confirm_letter: CHARACTER_32): BOOLEAN
		do
			lio.put_string (prompt)
			Result := entered_letter (confirm_letter)
			lio.put_new_line
		end

	approved_action_y_n (prompt: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := approved_action (prompt + Yes_no_choices, 'y')
		end

	entered_letter (a_letter: CHARACTER_32): BOOLEAN
			-- True if user line input started with letter (case insensitive)
		local
			first: CHARACTER_32
		do
			io.read_line
			if io.last_string.count > 0 then
				first := Console.decoded (io.last_string) [1]
			end
			Result := first.as_lower = a_letter.as_lower
		end

feature -- Basic operations

	preinput_line (prompt, value: READABLE_STRING_GENERAL)
		do
			Preinput_table [as_zstring (prompt)] := as_zstring (value)
		end

	press_enter
		local
			l: ZSTRING
		do
			l := line ("Press <ENTER> to continue")
			lio.put_new_line
		end

	wipe_out_preinputs
		do
			Preinput_table.wipe_out
		end

feature -- Input

	dir_path (prompt: READABLE_STRING_GENERAL): DIR_PATH
			--
		do
			Result := path (prompt)
		end

	file_path (prompt: READABLE_STRING_GENERAL): FILE_PATH
			--
		do
			Result := path (prompt)
		end

	integer (prompt: READABLE_STRING_GENERAL): INTEGER
		local
			input: EL_USER_INPUT_VALUE [INTEGER]
		do
			create input.make (prompt)
			Result := input.value
		end

	line (prompt: READABLE_STRING_GENERAL): ZSTRING
			--
		do
			lio.put_labeled_string (prompt, "")
			if Preinput_table.has_key (as_zstring (prompt)) then
				Result := Preinput_table.found_item
				lio.put_new_line
			else
				io.read_line
				Result := Console.decoded (io.last_string)
			end
		end

	path (prompt: READABLE_STRING_GENERAL): ZSTRING
			--
		do
			Result := line (prompt)
			Result.adjust
			across 1 |..| 2 as type loop
				if Result.has_quotes (type.item) then
					Result.remove_quotes
				end
			end
		end

feature {NONE} -- Constants

	Preinput_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		-- used for auto-testing to avoid user prompts on calling `line'
		once
			create Result.make_size (3)
		end

	Yes_no_choices: STRING
		once
			Result := " (y/n) "
		end

end