note
	description: "List from XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 9:17:12 GMT (Thursday 7th September 2023)"
	revision: "12"

deferred class
	EL_LIST_FROM_XML [G -> EL_XML_CREATEABLE_OBJECT create make end]

feature {NONE} -- Initaliazation

	make_from_file (file_path: FILE_PATH)
			--
		do
			make_from_xdoc (create {EL_XML_DOC_CONTEXT}.make_from_file (file_path))
		end

	make_from_string (xml_string: STRING)
		do
			make_from_xdoc (create {EL_XML_DOC_CONTEXT}.make_from_string (xml_string))
		end

	make_from_xdoc (xdoc: EL_XML_DOC_CONTEXT)
		local
			node_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			node_list := xdoc.context_list (Node_list_xpath)
			make_with_count (node_list.count)
			from node_list.start until node_list.after loop
				extend (new_item (node_list.context))
				node_list.forth
			end
		end

	make_with_count (count: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	extend (v: G)
		deferred
		end

	new_item (node: EL_XPATH_NODE_CONTEXT): G
		do
			create Result.make (node)
		end

	Node_list_xpath: READABLE_STRING_GENERAL
		deferred
		end

end