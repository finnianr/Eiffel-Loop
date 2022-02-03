note
	description: "Class file name normalizer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 13:00:15 GMT (Thursday 3rd February 2022)"
	revision: "5"

class
	CLASS_FILE_NAME_NORMALIZER

inherit
	CLASS_NAME_EDITOR
		redefine
			on_class_name
		end

create
	make

feature {NONE} -- Events

	on_class_name (text: EL_STRING_VIEW)
			--
		local
			name: STRING
		do
			name := text
			if class_name.is_empty then
				set_class_name (name)
			end
			put_string (name)
		end

end