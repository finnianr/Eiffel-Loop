note
	description: "Cursor used in conjunction with [$source EL_ITERABLE_SCOPE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-23 11:57:31 GMT (Saturday 23rd April 2022)"
	revision: "1"

class
	EL_SCOPE_CURSOR [G]

inherit
	ITERATION_CURSOR [G]

create
	make

feature {NONE} -- Initialization

	make (a_scope: like scope)
		do
			scope := a_scope
			item := scope.new_item
		end

feature -- Access

	item: G

feature -- Status query

	after: BOOLEAN

feature -- Status change

	start
		do
			after := False
		end

feature -- Element change

	set_item (a_item: like item)
		do
			item := a_item
		end

feature -- Cursor movement

	forth
		do
			after := True
			scope.on_exit (item)
		end

feature {NONE} -- Internal attributes

	scope: EL_ITERABLE_SCOPE [G]
end