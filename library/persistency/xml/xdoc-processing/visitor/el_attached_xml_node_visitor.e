note
	description: "Node visitor that is attached to a `EL_XML_NODE_TREE_PROCESSOR'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 16:10:34 GMT (Thursday 7th July 2016)"
	revision: "5"

deferred class
	EL_ATTACHED_XML_NODE_VISITOR

inherit
	EL_XML_NODE_VISITOR

feature -- Basic operations

	apply_from_stream (a_object: like processor; a_stream: IO_MEDIUM)
			--
		do
			set_processor (a_object)
			do_from_stream (a_stream)
		end

	apply_from_string (a_object: like processor; a_str: STRING)
			--
		do
			set_processor (a_object)
			do_from_string (a_str)
		end

feature -- Element change

	set_processor (a_processor: like processor)
			--
		do
			processor := a_processor
		end

feature -- Factory

	new_file (file_path: EL_FILE_PATH): FILE
		do
			create {PLAIN_TEXT_FILE} Result.make_open_read (file_path)
		end

feature {NONE} -- Implementation

	processor: EL_XML_NODE_TREE_PROCESSOR [EL_ATTACHED_XML_NODE_VISITOR]

end
