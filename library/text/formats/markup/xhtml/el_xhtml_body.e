note
	description: "XHTML body content without html tags or declaration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 23:17:44 GMT (Wednesday 8th November 2023)"
	revision: "2"

class
	EL_XHTML_BODY

inherit
	ANY

	EL_MODULE_FILE

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make

feature {NONE} -- Initialization

	make (body_path: FILE_PATH; edit_action: detachable PROCEDURE [STRING])
		do
			if body_path.exists then
				content := File.plain_text (body_path)
			else
				create content.make_empty
			end
			name := body_path.base_name
			if attached edit_action as edit then
				edit (content)
			end
		end

feature -- Access

	content: STRING

	name: ZSTRING

	to_xhtml_doc: STRING
		do
			across String_8_scope as scope loop
				XHTML_template.set_variables_from_array (<<
					["title", scope.copied_utf_8_item (name)], ["body", content]
				>>)
				Result := XHTML_template.substituted
			end
		end

feature -- Element change

	set_name (a_name: ZSTRING)
		do
			name := a_name
		end

feature {NONE} -- Constants

	XHTML_template: EL_STRING_8_TEMPLATE
		once
			create Result.make ("[
				<?xml version="1.0" encoding="UTF-8"?>
				<html>
					<head>
						<title>$title</title>
					</head>
					<body>
						$body
					</body>
				</html>
			]")
		end

end