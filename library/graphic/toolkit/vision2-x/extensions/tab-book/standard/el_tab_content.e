note
	description: "Tab content"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 14:11:51 GMT (Thursday 24th February 2022)"
	revision: "6"

deferred class
	EL_TAB_CONTENT [W -> EV_POSITIONABLE]

inherit
	EL_MODULE_DEFERRED_LOCALE

feature {EL_FIXED_TAB_BOOK} -- Initialization

	initialize
		deferred
		end

	make (a_tab_book: like tab_book)
		do
			tab_book := a_tab_book
			initialize
		end

feature -- Access

	border_cms: REAL
		deferred
		end

	padding_cms: REAL
		deferred
		end

	display_name: ZSTRING
		deferred
		end

feature {EL_NOTEBOOK_TAB} -- Factory

	new_box: EL_VERTICAL_BOX
			--
		do
			create Result.make_unexpanded (border_cms, padding_cms, new_widgets)
		end

	new_widgets: ARRAY [EV_WIDGET]
		deferred
		end

feature {NONE} -- Internal attributes

	window: W
		do
			Result := tab_book.window
		end

	tab_book: EL_FIXED_TAB_BOOK [W]

end