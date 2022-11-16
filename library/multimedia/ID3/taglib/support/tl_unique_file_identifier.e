note
	description: "Tl unique file identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	TL_UNIQUE_FILE_IDENTIFIER

feature -- Access

	identifier: STRING
		deferred
		end

	owner: ZSTRING
		deferred
		end

feature -- Status query

	is_default: BOOLEAN
		deferred
		end

feature -- Element change

	set_identifier (a_identifier: STRING)
		deferred
		ensure
			set: not is_default implies identifier ~ a_identifier
		end

	set_owner (a_owner: READABLE_STRING_GENERAL)
		deferred
		ensure
			set: not is_default implies a_owner.same_string (owner)
		end

feature -- Comparison

	same_as (other: like Current): BOOLEAN
		do
			Result := owner ~ other.owner and then identifier ~ other.identifier
		end

end