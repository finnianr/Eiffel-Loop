note
	description: "Xpath to a document node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-12 11:48:27 GMT (Saturday 12th August 2023)"
	revision: "1"

class
	EL_XPATH_CONTEXT

inherit
	EL_MAKEABLE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			set_default_attributes
		end

feature -- Element change

	extend_xpath (a_node: EL_DOCUMENT_NODE_STRING)
			--
		do
			if xpath.count > 0 then
				xpath.append_character ('/')
			end
			a_node.extend_xpath (xpath)
		end

	remove_xpath_step
			--
		require
			xpath_prunable: is_xpath_prunable
		local
			separator_pos: INTEGER
		do
			separator_pos := xpath.last_index_of ('/', xpath.count)
			if separator_pos > 0 then
				xpath.remove_tail (xpath.count - (separator_pos - 1))

			else
				xpath.wipe_out
			end
		end

	set_node (a_node: EL_DOCUMENT_NODE_STRING)
			--
		do
			node := a_node
		end

feature -- Status query

	is_xpath_attribute: BOOLEAN
			--
		local
			separator_pos: INTEGER
		do
			separator_pos := xpath.last_index_of ('/', xpath.count)
			if xpath.count > 0 and then
				xpath [1] = '@' or (separator_pos > 0 and then xpath [separator_pos + 1] = '@')
			then
				Result := true
			end
		end

	is_xpath_prunable: BOOLEAN
			--
		do
			Result := not xpath.is_empty
		end

	xpath_has_at_least_one_element: BOOLEAN
			--
		do
			Result := xpath.has ('/')
		end

feature {EL_DOCUMENT_CLIENT} -- Implementation

	set_default_attributes
		do
			node := Default_node
			create xpath.make_empty
		end

feature {EL_DOCUMENT_CLIENT} -- Internal attributes

	node: EL_DOCUMENT_NODE_STRING note option: transient attribute end

	xpath: STRING note option: transient attribute end

feature {NONE} -- Constant

	Default_node: EL_DOCUMENT_NODE_STRING
		once
			create Result.make_default
		end

end