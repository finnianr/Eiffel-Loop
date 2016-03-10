note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TOOL_BAR_RADIO_BUTTON_GRID

inherit
	EV_VERTICAL_BOX
		rename
			count as row_count,
			extend as extend_box,
			last as last_tool_bar
		export
			{NONE} all
		redefine
			create_implementation, implementation
		end

feature -- Initialization

	make (rows, cols: INTEGER)
			--
		local
			i: INTEGER
		do
			default_create
			create radio_group.make
			column_count := cols
			from i := 1 until i > rows loop
				extend_box (create {EL_SHARED_RADIO_GROUP_TOOL_BAR}.make (radio_group))
				i := i + 1
			end
			start
		end

feature -- Access

	last: EV_TOOL_BAR_RADIO_BUTTON

feature -- Element change

	extend (button: EV_TOOL_BAR_RADIO_BUTTON)
			--
		require
			not_full: not is_full
		do
			if tool_bar.count = column_count then
				forth
			end
			tool_bar.extend (button)
			last := button
		end

feature -- Status query

	is_full: BOOLEAN
			--
		do
			Result := index = row_count and tool_bar.count = column_count
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EL_TOOL_BAR_RADIO_BUTTON_GRID_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	radio_group: LINKED_LIST [EV_TOOL_BAR_RADIO_BUTTON_IMP]

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_TOOL_BAR_RADIO_BUTTON_GRID_IMP} implementation.make
		end

	column_count: INTEGER

	tool_bar: EL_SHARED_RADIO_GROUP_TOOL_BAR
			--
		do
			if attached {like tool_bar} item as bar then
				Result := bar
			end
		end


end
