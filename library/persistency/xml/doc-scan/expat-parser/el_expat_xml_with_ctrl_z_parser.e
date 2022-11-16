note
	description: "[
		Parses XML from a stream until a Ctrl-z character is encounterd.
		Use for parsing a network stream of XML.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_EXPAT_XML_WITH_CTRL_Z_PARSER

inherit
	EL_EXPAT_XML_PARSER
		redefine
			parse_incremental_from_stream
		end

create
	make

feature {EL_PARSER_OUTPUT_MEDIUM} -- Implementation

	parse_incremental_from_stream (a_stream: IO_MEDIUM)
		local
			delimiter_found: BOOLEAN; str: STRING
		do
			source := new_stream_source (a_stream)
			from scanner.on_start_document until not is_correct or delimiter_found loop
				a_stream.read_stream (read_block_size)
				str := a_stream.last_string
				if str.item (str.count) = Ctrl_z_delimiter then
					delimiter_found := True
					str.remove_tail (1)
				end
				parse_string_and_set_error (str, False)
			end
		end

feature {NONE} -- Constants

	Ctrl_z_delimiter: CHARACTER = '%/26/'

end