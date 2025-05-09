note
	description: "Contract support for converting between keys and values using an agent function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-09 6:01:14 GMT (Friday 9th May 2025)"
	revision: "2"

deferred class
	EL_KEY_VALUE_CONVERSION [KEY, VALUE]

inherit
	EL_ROUTINES

feature -- Contract support

	valid_key_to_value (f: FUNCTION [KEY, VALUE]): BOOLEAN
		local
			info: EL_FUNCTION_INFO
		do
			create info.make (Void, f.generating_type)
			Result := info.valid_single_argument ({KEY})
		end

	valid_value_to_key (f: FUNCTION [VALUE, KEY]): BOOLEAN
		local
			info: EL_FUNCTION_INFO
		do
			create info.make (Void, f.generating_type)
			Result := info.valid_single_argument ({VALUE})
		end

end