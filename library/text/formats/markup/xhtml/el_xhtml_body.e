note
	description: "XHTML body content without html tags or declaration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 11:42:09 GMT (Wednesday 6th November 2024)"
	revision: "4"

class
	EL_XHTML_BODY

inherit
	ANY

	EL_MODULE_FILE

	EL_SHARED_STRING_8_BUFFER_POOL

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
			if attached String_8_pool.borrowed_item as borrowed then
				XHTML_template.put_array (<<
					["title", borrowed.copied_general_as_utf_8 (name)], ["body", content]
				>>)
				Result := XHTML_template.substituted
				borrowed.return
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