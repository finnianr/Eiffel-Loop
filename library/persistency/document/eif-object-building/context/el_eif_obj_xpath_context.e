note
	description: "Eiffel object xpath context"
	notes: "[
		**WARNING**

		Be careful not to allow node itself to be a assigned to a fields of type ${STRING_8}.
		Use explict conversion:

			str := node.to_string_8
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "24"

deferred class
	EL_EIF_OBJ_XPATH_CONTEXT

inherit
	EL_XPATH_CONTEXT
		rename
			make as make_default
		end

feature {EL_DOCUMENT_CLIENT} -- Event handler

	on_context_exit
			-- Called when the parser leaves the current context
		do
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
		-- Called each time the XML parser returns from the context set by 'set_next_context'
		-- Can be used to carry out processing on an object passed to 'set_next_context'
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

	reset_next_context
			--
		do
			next_context := Void
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

end