note
	description: "[
		${TYPE_VARIABLE_SUBSTITUTION} for outputing to Github **Contents.md** file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:52:58 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	GITHUB_TYPE_VARIABLE_SUBSTITUTION

inherit
	TYPE_VARIABLE_SUBSTITUTION
		rename
			make as make_type,
			substitute_html as substitute_links
		redefine
			new_link_markup
		end

create
	make

feature {NONE} -- Initialization

	make (a_repository_web_address: ZSTRING)
		do
			make_type
			repository_web_address := a_repository_web_address
		end

feature {NONE} -- Implementation

	new_link_markup (a_path: FILE_PATH; type_name: ZSTRING; is_ise_path: BOOLEAN): ZSTRING
		local
			path: ZSTRING
		do
			if path /~ Unknown and then not is_ise_path then
				path := char ('/').joined (repository_web_address, a_path.to_string)
			else
				path := a_path
			end
			Result := Github_link_template #$ [path, type_name]
		end

feature {NONE} -- Internal attributes

	repository_web_address: ZSTRING

end