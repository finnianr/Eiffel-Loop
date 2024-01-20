note
	description: "Command line interface to ${VCF_CONTACT_SPLITTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "19"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	VCF_CONTACT_NAME_APPLICATION
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