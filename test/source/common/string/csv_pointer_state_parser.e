note
	description: "CSV parser for lines encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-22 13:06:11 GMT (Wednesday 22nd December 2021)"
	revision: "1"

class
	CSV_POINTER_STATE_PARSER

inherit
	EL_REFLECTION_HANDLER

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			create fields.make (0)
			create field_string.make_empty
		end

feature -- Access

	count: INTEGER

	fields: EL_ARRAYED_MAP_LIST [STRING, ZSTRING]

feature -- Basic operations

	parse (line: STRING)
		do
			count := count + 1
			column := 0
			traverse ($find_comma, line)
			add_value
		end

	set_object (object: EL_REFLECTIVE)
		local
			table: EL_REFLECTED_FIELD_TABLE
			field: like fields
		do
			table := object.field_table; field := fields
			from field.start until field.after loop
				if table.has_imported (field.item_key, object) then
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

	frozen check_back_slash (str: STRING; i: INTEGER; c: CHARACTER)
		local
			escape: CHARACTER
		do
			inspect c
				when 'r' then escape := '%R'
				when 'n' then escape := '%N'
			else
			end
			if escape.natural_32_code.to_boolean then
				field_string.append_character (escape)
				state := previous_state
			else
				field_string.append_character (Back_slash)
				if c = Comma and then previous_state = $find_comma then
					find_comma (str, i, c)
					state := $find_comma

				elseif c = Double_quote and then previous_state = $find_end_quote then
					find_end_quote (str, i, c)
				else
					field_string.append_character (c)
					state := previous_state
				end
			end
		end

	frozen check_escaped_quote (str: STRING; i: INTEGER; c: CHARACTER)
			-- check if last character was escape quote
		do
			inspect c
				when Comma then
					add_value
					state := $find_comma

				when Double_quote then
					field_string.append_character (c)
					state := $find_end_quote

			else -- last quote was end quote
				state := $find_comma
			end
		end

	frozen find_comma (str: STRING; i: INTEGER; c: CHARACTER)
			--
		do
			inspect c
				when Comma then
					add_value

				when Double_quote then
					state := $find_end_quote

				when Back_slash then
					previous_state := $find_comma
					state := $check_back_slash

			else
				field_string.append_character (c)
			end
		end

	frozen find_end_quote (str: STRING; i: INTEGER; c: CHARACTER)
			--
		do
			inspect c
				when Double_quote then
					state := $check_escaped_quote
				when Back_slash then
					previous_state := $find_end_quote
					state := $check_back_slash
			else
				field_string.append_character (c)
			end
		end

feature {NONE} -- Implementation

	add_value
		do
			column := column + 1
			if count = 1 then
				fields.extend (field_string.twin, Empty_string)
			else
				fields.i_th (column).value := new_zstring
			end
			field_string.wipe_out
		end

	call (str: STRING; i: INTEGER; c: CHARACTER)
		do
			if state = $check_back_slash then
				check_back_slash (str, i, c)

			elseif state = $check_escaped_quote then
				check_escaped_quote (str, i, c)

			elseif state = $find_comma then
				find_comma (str, i, c)

			elseif state = $find_end_quote then
				find_end_quote (str, i, c)
			end
		end

	traverse (initial_state: POINTER; string: STRING)
			--
		local
			l_final, i, l_count: INTEGER
		do
			l_count := string.count
			from i := 1; state := initial_state until i > l_count or state = default_pointer loop
				call (string, i, string [i])
				i := i + 1
			end
		end

	new_zstring: ZSTRING
		do
			create Result.make_from_general (field_string)
		end

feature {NONE} -- Internal attributes

	column: INTEGER

	field_string: STRING

	previous_state: POINTER

	state: POINTER

feature {NONE} -- Constants

	Back_slash: CHARACTER = '\'

	Comma: CHARACTER = ','

	Double_quote: CHARACTER = '"'
end