note
	description: "Summary description for {WEB_PROPERTIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:39:21 GMT (Monday 24th June 2013)"
	revision: "2"

class
	WEB_PUBLISHER_CONFIG

inherit
	EL_MODULE_EVOLICITY_ENGINE

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
			Evolicity_engine.set_template_from_file (default_template)
		end

feature -- Access

	default_template: EL_FILE_PATH

	web_root_dir: EL_DIR_PATH

end
