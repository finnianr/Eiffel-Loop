note
	description: "Summary description for {EL_IP_ADAPTER_INFO_COMMAND_IMPL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_IP_ADAPTER_INFO_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make
	
feature -- Access

	template: STRING = "nm-tool"

end
