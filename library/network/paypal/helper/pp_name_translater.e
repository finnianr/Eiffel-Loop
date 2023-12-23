note
	description: "Translation example: l_hosted_button_id <--> L_HOSTEDBUTTONID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-23 9:24:25 GMT (Saturday 23rd December 2023)"
	revision: "5"

class
	PP_NAME_TRANSLATER

inherit
	EL_CAMEL_CASE_TRANSLATER
		redefine
			exported, new_camel_name, Default_case
		end

create
	make

feature -- Conversion

	exported (eiffel_name: READABLE_STRING_8): STRING
		do
			Result := Precursor (eiffel_name)
			if eiffel_name.starts_with (L_) then
				Result.insert_character ('_', 2)
			end
		end

feature {NONE} -- Implementation

	new_camel_name (eiffel_name: READABLE_STRING_8): STRING
		do
			create Result.make_from_string (eiffel_name)
			Result.prune_all ('_')
			if eiffel_name.starts_with (L_) then
				Result.insert_character ('_', 2)
			end
		end

feature {NONE} -- Constants

	Default_case: NATURAL_8
		once
			Result := {EL_CASE}.upper
		end

	L_: STRING = "l_"
end