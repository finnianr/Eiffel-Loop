note
	description: "Command line interface to [$source VCF_CONTACT_SPLITTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-12 15:57:04 GMT (Wednesday 12th January 2022)"
	revision: "15"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_SPLITTER]
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

	Option_name: STRING = "split_vcf"

	Description: STRING = "Split VCF contacts file into separate files"

end