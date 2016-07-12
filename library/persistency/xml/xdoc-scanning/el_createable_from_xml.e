note
	description: "[
		Object that is createable from XML parse events
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 10:21:57 GMT (Friday 1st July 2016)"
	revision: "5"

deferred class
	EL_CREATEABLE_FROM_XML

inherit
	EXCEPTIONS
		rename
			class_name as exception_class_name
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make_default
			--
		deferred
		end

	make_from_binary_file (a_file_path: EL_FILE_PATH)
			--
		do
			make_default
			build_from_binary_file (a_file_path)
		end

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		require
			path_exists: a_file_path.exists
		do
			make_default
			build_from_file (a_file_path)
		end

	make_from_binary_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			make_default
			build_from_binary_stream (a_stream)
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

	build_from_binary_file (a_file_path: EL_FILE_PATH)
			--
		do
			set_binary_node_source
			build_from_file (a_file_path)
		end

	build_from_file (a_file_path: EL_FILE_PATH)
			--
		require
			path_exists: a_file_path.exists
		local
			xml_source: IO_MEDIUM
		do
			if node_source.is_plain_text_event_source or node_source.is_pyxis_text_event_source then
				create {PLAIN_TEXT_FILE} xml_source.make_open_read (a_file_path)

			elseif node_source.is_binary_event_source then
				create {RAW_FILE} xml_source.make_open_read (a_file_path)

			else
				raise ("Invalid event source type")
			end
			build_from_stream (xml_source)
			if xml_source.is_open_read then
				xml_source.close
			end
		end

	build_from_binary_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			set_binary_node_source
			node_source.apply_from_stream (Current, a_stream)
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

	set_binary_node_source
			--
		do
			node_source.set_binary_node_source
		end

	set_plain_text_end_delimited_source
			--
		do
			node_source.set_plain_text_end_delimited_source
		end

	set_plain_text_source
			--
		do
			node_source.set_plain_text_source
		end

	set_pyxis_text_source
			--
		do
			node_source.set_pyxis_text_source
		end

feature {NONE} -- Implementation

	node_source: EL_XML_NODE_SCAN_SOURCE
			--
		deferred
		end

end
