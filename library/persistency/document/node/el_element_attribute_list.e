note
	description: "Document element attribute list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 8:17:42 GMT (Monday 12th July 2021)"
	revision: "11"

class
	EL_ELEMENT_ATTRIBUTE_LIST

inherit
	ARRAYED_LIST [EL_ELEMENT_ATTRIBUTE_NODE_STRING]
		rename
			make as make_list,
			item as node,
			extend as extend_list,
			wipe_out as reset
		export
			{NONE} all
			{ANY} default_pointer,
				start, after, forth, count, node, is_empty, i_th, first, last, index, go_i_th, reset

		redefine
			all_default
		end

	EL_ENCODING_BASE
		rename
			make as make_encoding,
			set_from_other as set_encoding_from_other
		export
			{NONE} all
			{EL_DOCUMENT_CLIENT} set_encoding_from_other
		end

	EL_DOCUMENT_CLIENT
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			make_list (Default_size)
			create node_cache.make (Default_size)
			from until node_cache.full loop
				node_cache.extend (create {like node}.make_empty)
			end
			reset
		end

feature -- Element change

	extend (document_dir: EL_DIR_PATH)
		do
			if count = node_cache.upper then
				node_cache.extend (create {like node}.make_empty)
			end
			extend_list (node_cache [count + 1])
			finish
			node.set_document_dir (document_dir)
			last.set_encoding_from_other (Current)
		end

feature {NONE} -- Implementation

	node_cache: ARRAYED_LIST [like node]

feature -- Constants

	Default_size: INTEGER = 5

	All_default: BOOLEAN = True

end