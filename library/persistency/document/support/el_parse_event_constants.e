note
	description: "Xml parse event stream"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_PARSE_EVENT_CONSTANTS

feature -- Event codes

	PE_attribute_text: INTEGER = 8

	PE_comment_text: INTEGER = 12

	PE_end_document: INTEGER = 5

	PE_end_tag: INTEGER = 3

	PE_existing_attribute_name: INTEGER = 6

	PE_existing_processing_instruction: INTEGER = 10

	PE_existing_start_tag: INTEGER = 2

	PE_new_attribute_name: INTEGER = 7

	PE_new_processing_instruction: INTEGER = 11

	PE_new_start_tag: INTEGER = 1

	PE_start_document: INTEGER = 4

	PE_text: INTEGER = 9

feature -- Constants

	Name_index_table_size: INTEGER = 31

feature {NONE} -- Constants

	Default_io_medium: EL_STRING_8_IO_MEDIUM
		once
			create Result.make (0)
		end

end