note
	description: "[
		${TYPE_VARIABLE_SUBSTITUTION} for outputing to Github **Contents.md** file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 9:44:01 GMT (Monday 22nd January 2024)"
	revision: "4"

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

	new_link_markup (link: CLASS_LINK): ZSTRING
		do
			Result := link.github_markup (repository_web_address)
		end

feature {NONE} -- Internal attributes

	repository_web_address: ZSTRING

end