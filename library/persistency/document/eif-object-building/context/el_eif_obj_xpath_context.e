note
	description: "Eiffel object xpath context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 10:06:36 GMT (Saturday 31st December 2022)"
	revision: "19"

deferred class
	EL_EIF_OBJ_XPATH_CONTEXT

inherit
	EL_MAKEABLE
		rename
			make as make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			set_default_attributes
		end

feature {EL_DOCUMENT_CLIENT} -- Event handler

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
		-- Called each time the XML parser returns from the context set by 'set_next_context'
		-- Can be used to carry out processing on an object passed to 'set_next_context'
		do
		end

	on_context_exit
			-- Called when the parser leaves the current context
		do
		end

feature -- Access

	next_context: detachable EL_EIF_OBJ_XPATH_CONTEXT note option: transient attribute end
		-- Next object context

feature -- Basic operations

	do_with_xpath
			-- Apply building action if xpath has one assigned
		deferred
		end

feature -- Element change

	set_node (a_node: EL_DOCUMENT_NODE_STRING)
			--
		do
			node := a_node
		end

	set_collection_context (collection: COLLECTION [EL_EIF_OBJ_XPATH_CONTEXT]; new_item: EL_EIF_OBJ_XPATH_CONTEXT)
		-- set next context as extended collection last item
		do
			collection.extend (new_item)
			set_next_context (new_item)
		end

	set_next_context (context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			next_context := context
			context.set_node (node)
		end

	add_xpath_step (tag_name: ZSTRING)
			--
		do
			if not xpath.is_empty then
				xpath.append_character (xpath_step_separator)
			end
			xpath.append (tag_name)
		end

	remove_xpath_step
			--
		require
			xpath_prunable: is_xpath_prunable
		local
			separator_pos: INTEGER
		do
			separator_pos := xpath.last_index_of (xpath_step_separator, xpath.count)
			if separator_pos > 0 then
				xpath.remove_tail (xpath.count - (separator_pos - 1))

			else
				xpath.wipe_out
			end
		end

	reset_next_context
			--
		do
			next_context := Void
		end

feature -- Status query

	is_xpath_prunable: BOOLEAN
			--
		do
			Result := not xpath.is_empty
		end

	is_xpath_attribute: BOOLEAN
			--
		local
			separator_pos: INTEGER
		do
			separator_pos := xpath.last_index_of (xpath_step_separator, xpath.count)
			if xpath.count > 0 and then
				xpath.item (1) = '@' or (separator_pos > 0 and then xpath.item (separator_pos + 1) = '@')
			then
				Result := true
			end
		end

	xpath_has_at_least_one_element: BOOLEAN
			--
		do
			Result := xpath.has (xpath_step_separator)
		end

feature {EL_EIF_OBJ_XPATH_CONTEXT} -- Implementation

	set_default_attributes
		do
			node := Default_node
			create xpath.make_empty
		end

	node: EL_DOCUMENT_NODE_STRING note option: transient attribute end

	xpath: ZSTRING note option: transient attribute end

feature {NONE} -- Constant

	Xpath_step_separator: CHARACTER_32 = '/'

	Default_node: EL_DOCUMENT_NODE_STRING
		once
			create Result.make_default
		end

end