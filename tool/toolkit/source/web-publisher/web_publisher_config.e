note
	description: "Summary description for {WEB_PROPERTIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	WEB_PUBLISHER_CONFIG

inherit
	EL_MODULE_EVOLICITY_TEMPLATES

create
	make

feature {NONE} -- Initialization

	make (file_path: EL_FILE_PATH)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			web_root_dir := file_path.parent
			create root_node.make_from_file (file_path)
			default_template := web_root_dir + root_node.string_32_at_xpath ("/config/default-template")
			Evolicity_templates.put_from_file (default_template)
		end

feature -- Access

	default_template: EL_FILE_PATH

	web_root_dir: EL_DIR_PATH

end
