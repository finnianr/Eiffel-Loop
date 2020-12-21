note
	description: "Xml node event handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 15:58:31 GMT (Sunday 20th December 2020)"
	revision: "5"

deferred class
	EL_DOCUMENT_PARSE_EVENT_HANDLER

feature {EL_DOCUMENT_CLIENT} -- Parsing events

	on_start_document
			--
		deferred
		end

	on_end_document
			--
		deferred
		end

	on_start_tag (node: EL_DOCUMENT_NODE; attribute_list: EL_ELEMENT_ATTRIBUTE_LIST)
			--
		deferred
		end

	on_end_tag (node: EL_DOCUMENT_NODE)
			--
		deferred
		end

	on_content (node: EL_DOCUMENT_NODE)
			--
		deferred
		end

	on_comment (node: EL_DOCUMENT_NODE)
			--
		deferred
		end

	on_processing_instruction (node: EL_DOCUMENT_NODE)
			--
		deferred
		end
end