note
	description: "Summary description for {EL_CREATEABLE_FROM_DOCUMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-25 10:59:42 GMT (Friday 25th December 2015)"
	revision: "6"

deferred class
	EL_XML_NODE_TREE_PROCESSOR [G -> EL_ATTACHED_XML_NODE_VISITOR create make end]

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
		do
			if attached {G} Visitor_table.item ({like Current}, agent new_visitor) as l_visitor then
				visitor := l_visitor
			end
		end

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		require
			path_exists: a_file_path.exists
		do
			make_default
			do_from_file (a_file_path)
		end

	make_from_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			make_default
			do_from_stream (a_stream)
		end

	make_from_string (a_str: STRING)
			--
		do
			make_default
			do_from_string (a_str)
		end

feature -- Basic operations

	do_from_file (file_path: EL_FILE_PATH)
			--
		require
			path_exists: file_path.exists
		local
			file: FILE
		do
			file := visitor.new_file (file_path)
			do_from_stream (file)
			file.close
		end

	do_from_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			visitor.apply_from_stream (Current, a_stream)
		end

	do_from_string (a_string: STRING)
			--
		do
			visitor.apply_from_string (Current, a_string)
		end

feature {NONE} -- Implementation

	new_visitor: like visitor
		do
			create Result.make
		end

	visitor: G

feature {NONE} -- Constants

	Visitor_table: EL_TYPE_TABLE [EL_ATTACHED_XML_NODE_VISITOR]
		once
			create Result.make_equal (3)
		end

end