note
	description: "[
		${TYPE_VARIABLE_SUBSTITUTION} for outputing to Github **Contents.md** file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 18:13:24 GMT (Monday 22nd January 2024)"
	revision: "5"

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

	make (a_github_url: EL_DIR_URI_PATH)
		do
			make_type
			github_url := a_github_url
		end

feature {NONE} -- Implementation

	new_link_markup (link: CLASS_LINK): ZSTRING
		do
			Result := link.github_markdown (github_url)
		end

feature {NONE} -- Internal attributes

	github_url: EL_DIR_URI_PATH

end