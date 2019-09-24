note
	description: "Debian packager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-24 9:03:08 GMT (Tuesday   24th   September   2019)"
	revision: "1"

class
	EL_DEBIAN_PACKAGER

inherit
	EL_COMMAND

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_template_dir, a_output_dir: EL_DIR_PATH)
		do
			template_dir := a_template_dir; output_dir := a_output_dir
		end

feature -- Basic operations

	execute
		do
		end

feature {NONE} -- Internal attributes

	template_dir: EL_DIR_PATH

	output_dir: EL_DIR_PATH

end
