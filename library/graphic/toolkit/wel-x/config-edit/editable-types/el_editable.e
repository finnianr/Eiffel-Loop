note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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
