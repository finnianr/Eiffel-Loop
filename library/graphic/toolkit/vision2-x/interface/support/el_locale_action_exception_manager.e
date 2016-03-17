note
	description: "Summary description for {EL_LOCALE_ACTION_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:23:10 GMT (Saturday 26th December 2015)"
	revision: "5"

class
	EL_LOCALE_ACTION_EXCEPTION_MANAGER [D -> EL_ERROR_DIALOG create make end]

inherit
	EL_ACTION_EXCEPTION_MANAGER [D]
		redefine
			Default_title, Default_message
		end

	EL_MODULE_LOCALE

create
	make

feature {NONE} -- Constants

	Default_title: ZSTRING
		once
			Result := Locale * "Error"
		end

	Default_message: ZSTRING
		once
			Result := Locale * "{something bad happened}"
		end
end
