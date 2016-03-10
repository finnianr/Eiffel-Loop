note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

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

