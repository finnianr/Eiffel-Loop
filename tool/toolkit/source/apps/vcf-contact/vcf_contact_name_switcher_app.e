note
	description: "Command line interface to [$source VCF_CONTACT_NAME_SWITCHER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-12 21:19:27 GMT (Wednesday 12th January 2022)"
	revision: "15"

class
	VCF_CONTACT_NAME_SWITCHER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_NAME_SWITCHER]
		redefine
			Option_name
		end

create
	make

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

feature {NONE} -- Constants

	Option_name: STRING = "vcf_switch"

	Description: STRING = "Switch first and second names in vCard contacts file"

end