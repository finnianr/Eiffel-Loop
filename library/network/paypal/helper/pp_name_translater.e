note
	description: "Translation example: l_hosted_button_id <--> L_HOSTEDBUTTONID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 12:17:18 GMT (Saturday 25th June 2022)"
	revision: "2"

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

	exported (eiffel_name: STRING): STRING
		do
			Result := Precursor (eiffel_name)
			if eiffel_name.starts_with (L_) then
				Result.insert_character ('_', 2)
			end
		end

feature {NONE} -- Implementation

	new_camel_name (eiffel_name: STRING): STRING
		do
			Result := eiffel_name.twin
			Result.prune_all ('_')
			if eiffel_name.starts_with (L_) then
				Result.insert_character ('_', 2)
			end
		end

feature {NONE} -- Constants

	Default_case: NATURAL
		once
			Result := {EL_CASE}.upper
		end

	L_: STRING = "l_"
end