note
	description: "Contract support for ${EL_CASE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 9:52:44 GMT (Tuesday 8th April 2025)"
	revision: "1"

deferred class
	EL_CASE_CONTRACT

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature -- Contract Support

	frozen is_valid_case (case: NATURAL_8): BOOLEAN
		do
			inspect case
				when 0 .. {EL_CASE}.Sentence then
					Result := True
			else
			end
		end

end