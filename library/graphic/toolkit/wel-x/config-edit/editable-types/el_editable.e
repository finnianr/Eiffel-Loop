note
	description: "Editable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

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
