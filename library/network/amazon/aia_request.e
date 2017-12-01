note
	description: "Summary description for {AIA_REQUEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-28 11:38:29 GMT (Tuesday 28th November 2017)"
	revision: "1"

deferred class
	AIA_REQUEST

inherit
	EL_REFLECTIVELY_JSON_SETTABLE
		redefine
			name_adaptation
		end

feature {EL_FACTORY_CLIENT} -- Initialization

	make (json_list: EL_JSON_NAME_VALUE_LIST)
		do
			make_default
			set_from_json (json_list)
		end

feature -- Access

	json_response: STRING
		deferred
		end

feature {NONE} -- Implementation

	name_adaptation: like Standard_eiffel
		do
			Result := agent from_camel_case
		end
end
