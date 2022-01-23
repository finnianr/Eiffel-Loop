note
	description: "Vcf contact name sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:00:24 GMT (Sunday 23rd January 2022)"
	revision: "2"

deferred class
	VCF_CONTACT_NAME_SUB_APPLICATION

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Path to vcf contacts file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

end