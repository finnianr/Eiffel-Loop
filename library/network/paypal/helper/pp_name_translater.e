note
	description: "Translation example: l_hosted_button_id <--> L_HOSTEDBUTTONID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-15 15:30:47 GMT (Wednesday 15th June 2022)"
	revision: "1"

class
	PP_NAME_TRANSLATER

inherit
	EL_CAMEL_CASE_TRANSLATER
		rename
			make as make_default,
			make_upper as make
		redefine
			exported, new_camel_name
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

	L_: STRING = "l_"
end