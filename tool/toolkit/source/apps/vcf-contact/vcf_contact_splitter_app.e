note
	description: "Command line interface to [$source VCF_CONTACT_SPLITTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 11:53:34 GMT (Thursday 13th January 2022)"
	revision: "16"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	VCF_CONTACT_NAME_SUB_APPLICATION
		redefine
			command, Option_name
		end

create
	make

feature {NONE} -- Internal attributes

	command: VCF_CONTACT_SPLITTER

feature {NONE} -- Constants

	Option_name: STRING = "split_vcf"

end