note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STRING_REPLACE_CHARACTER_EDITION

inherit
	EL_STRING_INSERT_CHARACTER_EDITION
		rename
			insertion as replacement
		redefine
			apply
		end

create
	make

feature -- Basic operations

	apply (target: EL_ASTRING)
		do
			target.put (replacement, start_index)
		end

end
