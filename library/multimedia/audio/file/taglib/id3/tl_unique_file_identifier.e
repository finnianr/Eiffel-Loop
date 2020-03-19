note
	description: "Tl unique file identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 10:31:22 GMT (Thursday 19th March 2020)"
	revision: "1"

deferred class
	TL_UNIQUE_FILE_IDENTIFIER

inherit
	ANY
		redefine
			is_equal
		end

feature -- Access

	identifier: STRING
		deferred
		end

	owner: ZSTRING
		deferred
		end

feature -- Element change

	set_identifier (a_identifier: STRING)
		deferred
		ensure
			set: identifier ~ a_identifier
		end

	set_owner (a_owner: READABLE_STRING_GENERAL)
		deferred
		ensure
			set: a_owner.same_string (owner)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := owner ~ other.owner and then identifier ~ other.identifier
		end

end
