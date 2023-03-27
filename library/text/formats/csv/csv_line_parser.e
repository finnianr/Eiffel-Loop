note
	description: "CSV parser for lines encoded as Latin-1"
	tests: "Class [$source COMMA_SEPARATED_IMPORT_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 15:39:01 GMT (Monday 27th March 2023)"
	revision: "23"

class
	CSV_LINE_PARSER

inherit
	EL_STATE_MACHINE [CHARACTER_8]
		redefine
			make
		end

	EL_ZSTRING_CONSTANTS

	EL_REFLECTION_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create fields.make (0)
			create field_string.make_empty
			set_states
		end

feature -- Access

	count: INTEGER

	fields: EL_ARRAYED_MAP_LIST [STRING, ZSTRING]

feature -- Basic operations

	parse (line: STRING)
		do
			count := count + 1
			set_states
			column := 0
			traverse_iterable (p_find_comma, line)
			add_value
		end

	set_object (object: EL_REFLECTIVE)
		local
			table: EL_REFLECTED_FIELD_TABLE
			field: like fields
		do
			table := object.field_table; field := fields
			from field.start until field.after loop
				if table.has_imported_key (field.item_key) then
					table.found_item.set_from_string (object, field.item_value)
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

	check_back_slash (state_previous: like state; character: CHARACTER)
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
				if character = Comma and then state_previous = p_find_comma then
					find_comma (character)
					state := p_find_comma

				elseif character = Double_quote and then state_previous = p_find_end_quote then
					find_end_quote (character)
				else
					field_string.append_character (character)
					state := state_previous
				end
			end
		end

	check_escaped_quote (character: CHARACTER)
			-- check if last character was escape quote
		do
			inspect character
				when Comma then
					add_value
					state := p_find_comma

				when Double_quote then
					field_string.append_character (character)
					state := p_find_end_quote

			else -- last quote was end quote
				state := p_find_comma
			end
		end

	find_comma (character: CHARACTER)
			--
		do
			inspect character
				when Comma then
					add_value

				when Double_quote then
					state := p_find_end_quote

				when Back_slash then
					state := agent check_back_slash (p_find_comma, ?)

			else
				field_string.append_character (character)
			end
		end

	find_end_quote (character: CHARACTER)
			--
		do
			inspect character
				when Double_quote then
					state := p_check_escaped_quote
				when Back_slash then
					state := agent check_back_slash (p_find_end_quote, ?)
			else
				field_string.append_character (character)
			end
		end

feature {NONE} -- Implementation

	add_value
		do
			column := column + 1
			if count = 1 then
				fields.extend (field_string.twin, Empty_string)
			else
				fields.put_i_th_value (new_string, column)
			end
			field_string.wipe_out
		end

	set_states
		do
			p_find_end_quote := agent find_end_quote
			p_find_comma := agent find_comma
			p_check_escaped_quote := agent check_escaped_quote
		end

feature {NONE} -- Implementation

	new_string: ZSTRING
		do
			create Result.make_from_general (field_string)
		end

feature {NONE} -- Internal attributes

	column: INTEGER

	field_string: STRING

	p_check_escaped_quote: like state

	p_find_comma: like state

	p_find_end_quote: like state

feature {NONE} -- Constants

	Back_slash: CHARACTER = '\'

	Comma: CHARACTER = ','

	Double_quote: CHARACTER = '"'

end