note
	description: "Editable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_EDITABLE [G]
	
inherit
	EL_EDITABLE_VALUE
	
feature {NONE} -- Initialization

	make (an_edit_listener: EL_EDIT_LISTENER; value: like item)
			--
		do
			item := value
			edit_listener := an_edit_listener
		end

feature -- Access

	item: G

feature -- 	Conversion

	out: STRING
			--
		do
			Result := item.out
		end

end