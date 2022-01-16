note
	description: "[
		Same as [$source EL_THUNDERBIRD_XHTML_BODY_EXPORTER] but with **www** pruned from
		''export_steps''.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 16:52:04 GMT (Monday 10th January 2022)"
	revision: "1"

class
	EL_THUNDERBIRD_WWW_XHTML_BODY_EXPORTER

inherit
	EL_THUNDERBIRD_XHTML_BODY_EXPORTER
		redefine
			export_steps
		end

create
	make

feature {NONE} -- Implementation

	export_steps (mails_path: FILE_PATH): EL_PATH_STEPS
		do
			Result := config.export_steps (mails_path)
			Result.remove_tail (1)
		end

end