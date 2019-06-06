note
	description: "Encrypted search engine test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 9:16:29 GMT (Thursday 6th June 2019)"
	revision: "2"

class
	ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR

inherit
	SEARCH_ENGINE_TEST_EVALUATOR
		redefine
			item
		end

feature {NONE} -- Internal attributes

	item: ENCRYPTED_SEARCH_ENGINE_TEST_SET

end
