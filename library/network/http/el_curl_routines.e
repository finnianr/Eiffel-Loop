note
	description: "Summary description for {EL_CURL_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:54:36 GMT (Sunday 10th May 2015)"
	revision: "5"

class
	EL_CURL_ROUTINES

inherit
	CURL_EXTERNALS
		export
			{NONE} global_init, global_cleanup
		redefine
			default_create
		end

	EL_THREAD_ACCESS
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			create is_initialized
		end

feature -- Basic operations

	cleanup
			-- Thread safe cleanup when called with EL_MODULE_CURL
		do
			restrict_access (is_initialized)
				if is_initialized.item then
					global_cleanup
					is_initialized.set_item (False)
				end
			end_restriction (is_initialized)
		end

	initialize
			-- Thread safe initialization when called with EL_MODULE_CURL
		do
			restrict_access (is_initialized)
				if not is_initialized.item and then is_dynamic_library_exists then
					global_init
					is_initialized.set_item (True)
				end
			end_restriction (is_initialized)
		end

feature -- Status query

	is_initialized: EL_MUTEX_CREATEABLE_REFERENCE [BOOLEAN]

end
