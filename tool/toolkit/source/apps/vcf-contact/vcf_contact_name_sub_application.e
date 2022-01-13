note
	description: "Vcf contact name sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 11:05:47 GMT (Thursday 13th January 2022)"
	revision: "1"

deferred class
	VCF_CONTACT_NAME_SUB_APPLICATION

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Path to vcf contacts file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

end