note
	description: "A list of Xpath queryable XML nodes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-13 7:07:53 GMT (Thursday 13th July 2023)"
	revision: "7"

class
	EL_XPATH_NODE_CONTEXT_LIST

inherit
	EL_MODULE_LIO

	LINEAR [EL_XPATH_NODE_CONTEXT]
		rename
			item as context
		export
			{NONE} all
			{ANY} do_all, do_if, there_exists, for_all
		end

	ITERABLE [EL_XPATH_NODE_CONTEXT]

create
	make

feature {NONE} -- Initialization

	make (a_parent_context: like parent_context; a_xpath: READABLE_STRING_GENERAL)
			--
		do
			parent_context := a_parent_context
			create context.make_from_other (parent_context)
			xpath := a_xpath
		end

feature -- Access

	context: EL_XPATH_NODE_CONTEXT

	index: INTEGER

	new_cursor: EL_XPATH_NODE_CONTEXT_LIST_ITERATION_CURSOR
			--
		do
			create Result.make (Current)
			Result.start
		end

	xpath: READABLE_STRING_GENERAL

feature -- Cursor movement

	forth
			-- Move to next position if any.
		do
			context.query_forth
			index := index + 1
		end

	start
			-- Move to first position if any.
		do
			index := 0
			context.query_start (xpath)
			index := index + 1
		end

feature -- Measurement

	count: INTEGER
			--
		do
			Result := parent_context.query (Count_template #$ [xpath]).as_integer
		end

feature -- Status report

	after: BOOLEAN
			-- Is there no valid position to the right of current one?
		do
			Result := not context.match_found
		end

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := parent_context.is_empty_result_set (xpath)
		end

feature {EL_XPATH_NODE_CONTEXT_LIST_ITERATION_CURSOR} -- Implementation

	parent_context: EL_XPATH_NODE_CONTEXT

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {NONE} -- Constants

	Count_template: ZSTRING
		once
			Result := "count (%S)"
		end

end