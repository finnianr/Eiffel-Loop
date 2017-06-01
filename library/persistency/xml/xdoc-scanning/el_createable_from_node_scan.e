note
	description: "[
		Object that is createable from XML parse events
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-01 9:15:33 GMT (Thursday 1st June 2017)"
	revision: "5"

deferred class
	EL_CREATEABLE_FROM_NODE_SCAN

inherit
	EXCEPTIONS
		rename
			class_name as exception_class_name
		export
			{NONE} all
		end

	EL_BUILDABLE_FROM_FILE

feature {NONE} -- Initialization

	make_default
			--
		deferred
		end

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		require
			path_exists: a_file_path.exists
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
			stream: IO_MEDIUM
		do
			if Node_source.event_source.generating_type ~ {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE} then
				create {RAW_FILE} stream.make_open_read (a_file_path)
			else
				create {PLAIN_TEXT_FILE} stream.make_open_read (a_file_path)
			end
			build_from_stream (stream)
			if stream.is_open_read then
				stream.close
			end
		end

	build_from_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			Node_source.apply_from_stream (Current, a_stream)
		end

	build_from_string (a_string: STRING)
			--
		do
			Node_source.apply_from_string (Current, a_string)
		end

	build_from_lines (lines: LINEAR [ZSTRING])
			--
		do
			Node_source.apply_from_lines (Current, lines)
		end

feature -- Element change

	set_parser_type (type: TYPE [EL_PARSE_EVENT_SOURCE])
			--
		do
			Node_source.set_parser_type (type)
		end

feature {NONE} -- Implementation

	new_node_source: EL_XML_NODE_SCAN_SOURCE
			--
		deferred
		end

feature {NONE} -- Internal attributes

	Node_source: like new_node_source
		once ("OBJECT")
			Result := new_node_source
		end

end
