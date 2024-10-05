note
	description: "Factory for ${EL_DATE} and ${EL_TIME} related parsers"
	descendants: "[
			EL_DATE_OR_TIME_PARSER_FACTORY
				${EL_DATE_TIME_PARSER_FACTORY}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "4"

class
	EL_DATE_OR_TIME_PARSER_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			create code_string_table.make (11, agent new_code_string)
			create parser_table.make (11, agent new_parser)
		end

feature -- Access

	code_string (format: STRING): EL_DATE_TIME_CODE_STRING
		do
			Result := code_string_table.item (format)
		end

	date_time_parser (format: STRING): EL_DATE_TIME_PARSER
		do
			Result := parser_table.item (format)
		end

feature {NONE} -- Factory

	new_code_string (format: STRING): like code_string
		do
			create Result.make (format)
		end

	new_parser (format: STRING): like date_time_parser
		do
			Result := code_string (format).new_parser
		end

feature {NONE} -- Internal attributes

	code_string_table: EL_AGENT_CACHE_TABLE [like code_string, STRING]

	parser_table: EL_AGENT_CACHE_TABLE [like date_time_parser, STRING]

end