note
	description: "Object that is createable from document parse events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 15:45:31 GMT (Sunday 20th December 2020)"
	revision: "14"

deferred class
	EL_CREATEABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_FILE

	EL_LAZY_ATTRIBUTE
		rename
			item as node_source,
			new_item as new_node_source
		end

feature {NONE} -- Initialization

	make_default
		deferred
		end

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		do
			make_default
			build_from_file (a_file_path)
		end

	make_from_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			make_default
			build_from_stream (a_stream)
		end

	make_from_string (a_str: STRING)
			--
		do
			make_default
			build_from_string (a_str)
		end

feature -- Basic operations

	build_from_file (a_file_path: EL_FILE_PATH)
			--
		local
			file: FILE
		do
			file := node_source.event_source.new_file_stream (a_file_path)
			if file.exists then
				file.open_read
				build_from_stream (file)
				if file.is_open_read then
					file.close
				end
			end
		end

	build_from_lines (lines: ITERABLE [READABLE_STRING_GENERAL])
			--
		do
			node_source.apply_from_lines (Current, lines)
		end

	build_from_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			node_source.apply_from_stream (Current, a_stream)
		end

	build_from_string (a_string: STRING)
			--
		do
			node_source.apply_from_string (Current, a_string)
		end

feature -- Element change

	set_parser_type (type: TYPE [EL_PARSE_EVENT_SOURCE])
			--
		do
			node_source.set_parser_type (type)
		end

feature {NONE} -- Implementation

	new_node_source: EL_DOCUMENT_NODE_SCAN_SOURCE
		deferred
		end

	parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]
		deferred
		end

end