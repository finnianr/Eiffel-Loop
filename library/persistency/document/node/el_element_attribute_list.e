note
	description: "Document element attribute list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-17 14:19:25 GMT (Sunday 17th September 2023)"
	revision: "18"

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
			{EL_DOCUMENT_NODE_SCANNER} area

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
		undefine
			copy, is_equal
		end

	EL_DOCUMENT_CLIENT

create
	make

feature {NONE} -- Initialization

	make (a_document_dir: DIR_PATH)
			--
		do
			document_dir := a_document_dir
			make_default
			make_list (Default_size)
			create node_cache.make (Default_size)
			from until node_cache.full loop
				node_cache.extend (create {like node}.make (document_dir))
			end
			reset
		end

feature -- Element change

	extend
		do
			if count = node_cache.upper then
				node_cache.extend (create {like node}.make (document_dir))
			end
			extend_list (node_cache [count + 1])
			finish
			last.set_encoding_from_other (Current)
		end

feature {NONE} -- Implementation

	node_cache: ARRAYED_LIST [like node]

	document_dir: DIR_PATH

feature -- Constants

	Default_size: INTEGER = 5

	All_default: BOOLEAN = True

end