note
	description: "CSV parser for lines encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:28:11 GMT (Wednesday 17th October 2018)"
	revision: "9"

class
	EL_COMMA_SEPARATED_LINE_PARSER

inherit
	EL_STATE_MACHINE [CHARACTER_8]
		rename
			make as make_machine
		redefine
			call
		end

	EL_ZSTRING_CONSTANTS

	EL_REFLECTION_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			make_machine
			create fields.make (0)
			create field_string.make_empty
			set_states
		end

feature -- Access

	count: INTEGER

	fields: ARRAYED_LIST [TUPLE [name: STRING; value: ZSTRING]]

feature -- Basic operations

	parse (line: STRING)
		do
			count := count + 1
			set_states
			column := 0
			traverse_indexable (find_comma, line)
			add_value
		end

	set_object (object: EL_REFLECTIVE)
		local
			table: EL_REFLECTED_FIELD_TABLE
			field: like fields
		do
			table := object.field_table; field := fields
			from field.start until field.after loop
				if table.has_name (field.item.name, object) then
					table.found_item.set_from_string (object, field.item.value)
				end
				field.forth
			end
		end

feature -- Element change

	reset_count
		do
			count := 0
		end

feature {NONE} -- State handlers

	check_back_slash (state_previous: like find_comma; character: CHARACTER)
		local
			escape: CHARACTER
		do
			inspect character
				when 'r' then escape := '%R'
				when 'n' then escape := '%N'
			else
			end
			if escape.natural_32_code.to_boolean then
				field_string.append_character (escape)
				state := state_previous
			else
				field_string.append_character (Back_slash)
				if character = Comma and then state_previous = find_comma then
					do_find_comma (character)
					state := find_comma
				elseif character = Double_quote and then state_previous = find_end_quote then
					do_find_end_quote (character)
				else
					field_string.append_character (character)
					state := state_previous
				end
			end
		end

	do_check_escaped_quote (character: CHARACTER)
			-- check if last character was escape quote
		do
			inspect character
				when Comma then
					add_value
					state := find_comma

				when Double_quote then
					field_string.append_character (character)
					state := find_end_quote

			else -- last quote was end quote
				state := find_comma
			end
		end

	do_find_comma (character: CHARACTER)
			--
		do
			inspect character
				when Comma then
					add_value

				when Double_quote then
					state := find_end_quote

				when Back_slash then
					state := agent check_back_slash (find_comma, ?)

			else
				field_string.append_character (character)
			end
		end

	do_find_end_quote (character: CHARACTER)
			--
		do
			inspect character
				when Double_quote then
					state := check_escaped_quote
				when Back_slash then
					state := agent check_back_slash (find_end_quote, ?)
			else
				field_string.append_character (character)
			end
		end

feature {NONE} -- Implementation

	add_value
		do
			column := column + 1
			if count = 1 then
				fields.extend ([field_string.twin, Empty_string])
			else
				fields.i_th (column).value := new_string
			end
			field_string.wipe_out
		end

	call (item: CHARACTER)
		-- call state procedure with item
		do
			argument_tuple.put_character (item, 1)
			state.set_operands (argument_tuple)
			state.apply
		end

	set_states
		do
			find_end_quote := agent do_find_end_quote
			find_comma := agent do_find_comma
			check_escaped_quote := agent do_check_escaped_quote
		end

feature {NONE} -- Implementation

	new_string: ZSTRING
		do
			create Result.make_from_general (field_string)
		end

feature {NONE} -- Internal attributes

	check_escaped_quote: PROCEDURE [CHARACTER]

	column: INTEGER

	field_string: STRING

	find_comma: PROCEDURE [CHARACTER]

	find_end_quote: PROCEDURE [CHARACTER]

feature {NONE} -- Constants

	Back_slash: CHARACTER = '\'

	Comma: CHARACTER = ','

	Double_quote: CHARACTER = '"'

end
