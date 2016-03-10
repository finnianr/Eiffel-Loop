note
	description: "Summary description for {EL_HTTP_SERVLET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HTTP_SERVLET

inherit
	GOA_HTTP_SERVLET
		redefine
			servlet_config
		end

feature {NONE} -- Initialization

	make (a_servlet_config: like servlet_config)
		do
			servlet_config := a_servlet_config
			servlet_info := ""
		end

feature {NONE} -- Implementation

	servlet_config: EL_SERVLET_CONFIG

end
