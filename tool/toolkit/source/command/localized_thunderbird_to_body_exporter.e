note
	description: "Localized thunderbird to body exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 17:25:31 GMT (Thursday 27th September 2018)"
	revision: "1"

class
	LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER

inherit
	EL_THUNDERBIRD_LOCALIZED_HTML_EXPORTER
		export
			{EL_COMMAND_CLIENT} make_from_file
		end

create
	make_from_file

feature {NONE} -- Implementation

	new_reader (a_output_dir: EL_DIR_PATH): EL_THUNDERBIRD_EXPORT_AS_XHTML_BODY
		do
			create Result.make (a_output_dir, character_set)
		end

feature {NONE} -- Constants

	Is_language_code_first: BOOLEAN = True

end
