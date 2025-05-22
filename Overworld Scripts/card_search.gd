class_name CardSearch

static var operators = ["=","<",">","!="]

static var advancedSearchFunctions = {
	"cost": cmpCost,
	"mp": cmpCost,
	"tag": cmpTag,
	"alignment": cmpAlign,
	"god": cmpAlign,
	"role": cmpRole,
}

static func cmpCost(item: Card, query: String, comparator: String) -> bool:
	if comparator == "=":
		return item.cost == int(query)
	if comparator == ">":
		return item.cost > int(query)
	if comparator == "<":
		return item.cost < int(query)
	return false
	
static func cmpTag(item: Card, query: String, comparator: String) -> bool:
	if comparator == "=":
		print("q: ", query, ", ", item.tags)
		for tag in item.tags:
			if tag.to_lower() == query:
				print("qq:", tag.to_lower(),"=",query,">",tag.to_lower() == query)
				return true
	if comparator == "!=":
		for tag in item.tags:
			if tag.to_lower() != query:
				return true
		if len(item.tags) == 0:
			return true
	return false
	
static func cmpAlign(item: Card, query: String, comparator: String) -> bool:
	if comparator == "=":
		return query == Card.alignmentToString[item.alignment].to_lower()
	if comparator == "!=":
		return query != Card.alignmentToString[item.alignment].to_lower()
	return false
	
static func cmpRole(item: Card, query: String, comparator: String) -> bool:
	if comparator == "=":
		return query == item.role.to_lower() or query == item.role.to_lower()[0]
	if comparator == "!=":
		return query != item.role.to_lower() and query != item.role.to_lower()[0]
	return false


## Search function for cards. Returns true if card would be found in a given search query.
static func search(searchText: String, item: Card) -> bool:
	var searchFound = true
	print("total args for ", searchText, ": ", searchText.to_lower().split(", "))
	for arg in searchText.strip_edges().to_lower().split(", "):
		print("arg: ", arg)
		if len(arg) == 0 or arg.is_empty():
			continue
		
		#advanced search function
		if arg.begins_with("{") and arg.ends_with("}"):
			var subargs = null
			var comp = null
			for comps in operators:
				if arg.contains(comps):
					comp = comps
					subargs = arg.substr(1,len(arg)-2).split(comps)
					break
			print("subargs: ", subargs, " with ", comp)
			if subargs == null or comp == null or len(subargs) != 2 or subargs[0] not in advancedSearchFunctions.keys():
				continue
			var advFunction: Callable = advancedSearchFunctions[subargs[0]]
			var query = subargs[1]
			if !advFunction.call(item, query, comp):
				searchFound = false 
		else:
			#basic search function
			var matched = item.name.to_lower().contains(arg) or item.description.to_lower().contains(arg)
			if !matched:
				print("name filtered ", item.name)
				searchFound = false
	

	return searchFound
