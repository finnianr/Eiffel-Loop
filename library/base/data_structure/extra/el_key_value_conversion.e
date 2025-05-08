note
	description: "Contract support for converting between keys and values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 10:25:07 GMT (Thursday 8th May 2025)"
	revision: "1"

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