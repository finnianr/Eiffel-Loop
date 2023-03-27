note
	description: "CSV parser for lines encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 18:25:08 GMT (Monday 27th March 2023)"
	revision: "24"

deferred class
	CSV_STATE_PARSER [S]

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_REFLECTION_HANDLER

feature {NONE} -- Initialization

	make
		do
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
			traverse (s_find_comma, line)
			add_value
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
				if c = Comma and then previous_state = s_find_comma then
					find_comma (str, i, c)
					state := s_find_comma

				elseif c = Double_quote and then previous_state = s_find_end_quote then
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
					state := s_find_comma

				when Double_quote then
					field_string.append_character (c)
					state := s_find_end_quote

			else -- last quote was end quote
				state := s_find_comma
			end
		end

	frozen find_comma (str: STRING; i: INTEGER; c: CHARACTER)
			--
		do
			inspect c
				when Comma then
					add_value

				when Double_quote then
					state := s_find_end_quote

				when Back_slash then
					previous_state := s_find_comma
					state := s_check_back_slash

			else
				field_string.append_character (c)
			end
		end

	frozen find_end_quote (str: STRING; i: INTEGER; c: CHARACTER)
			--
		do
			inspect c
				when Double_quote then
					state := s_check_escaped_quote
				when Back_slash then
					previous_state := s_find_end_quote
					state := s_check_back_slash
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
				fields.put_i_th_value (new_string, column)
			end
			field_string.wipe_out
		end

feature {NONE} -- Deferred

	call (str: STRING; i: INTEGER; c: CHARACTER)
		deferred
		end

	set_states
		deferred
		end

feature {NONE} -- Implementation

	new_string: ZSTRING
		do
			create Result.make_from_general (field_string)
		end

	traverse (initial_state: like state; string: STRING)
			--
		local
			l_final, i, l_count: INTEGER
		do
			l_count := string.count
			from i := 1; state := initial_state until i > l_count or state = s_final loop
				call (string, i, string [i])
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	column: INTEGER

	field_string: STRING

	state: S

	previous_state: like state

	s_check_escaped_quote: like state

	s_check_back_slash: like state

	s_find_comma: like state

	s_find_end_quote: like state

	s_final: like state

feature {NONE} -- Constants

	Back_slash: CHARACTER = '\'

	Comma: CHARACTER = ','

	Double_quote: CHARACTER = '"'

end