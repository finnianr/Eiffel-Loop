note
	description: "[
		Object that applies XML parse events to the construction of an object
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 8:00:26 GMT (Monday 12th July 2021)"
	revision: "6"

deferred class
	EL_DOCUMENT_NODE_SCAN_SOURCE

inherit
	EL_DOCUMENT_NODE_SCANNER

feature -- Basic operations

	apply_from_stream (a_object: like seed_object; a_stream: IO_MEDIUM)
			--
		local
			file_path: EL_FILE_PATH
		do
			if attached {PLAIN_TEXT_FILE} a_stream as file then
				create file_path.make (file.name)
				last_node.set_document_dir (file_path.parent)
			end
			set_seed_object (a_object)
			scan_from_stream (a_stream)
		end

	apply_from_string (a_object: like seed_object; a_str: STRING)
			--
		do
			set_seed_object (a_object)
			scan (a_str)
		end

	apply_from_lines (a_object: like seed_object; lines: ITERABLE [READABLE_STRING_GENERAL])
		do
			set_seed_object (a_object)
			scan_from_lines (lines)
		end

feature -- Element change

	set_seed_object (a_object: like seed_object)
			--
		do
			seed_object := a_object
		end

feature {NONE} -- Implementation

	seed_object: EL_CREATEABLE_FROM_NODE_SCAN

end