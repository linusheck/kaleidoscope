local parser = require "dumbParser"

function expression_to_jani(expression)
    local tree = parser.parseExpression(expression)
    parser.printTree(tree)
    if not parser.isExpression(tree) then
        error("must be expression")
    end
    function callback(ast_node, parent, container, key)
        if ast_node.type == "identifier" then
            
        end
        parser.printNode(ast_node)
    end
    parser.traverseTree(tree, callback)
end

function traverse_to_jani(node, parent, container, k)
	local nodeType = node.type

	if nodeType == "identifier" or nodeType == "literal" then
        return node.name

	-- elseif nodeType == "table" then
	-- 	for _, tableField in ipairs(node.fields) do
	-- 		if tableField.key   and traverseTree(tableField.key,   leavesFirst, cb, node, tableField, "key")   then  return true  end
	-- 		if tableField.value and traverseTree(tableField.value, leavesFirst, cb, node, tableField, "value") then  return true  end
	-- 	end

	-- elseif nodeType == "lookup" then
	-- 	if node.object and traverseTree(node.object, leavesFirst, cb, node, node, "object") then  return true  end
	-- 	if node.member and traverseTree(node.member, leavesFirst, cb, node, node, "member") then  return true  end

	elseif nodeType == "unary" then
		if node.expression and traverseTree(node.expression, leavesFirst, cb, node, node, "expression") then  return true  end

	elseif nodeType == "binary" then
		if node.left  and traverseTree(node.left,  leavesFirst, cb, node, node, "left")  then  return true  end
		if node.right and traverseTree(node.right, leavesFirst, cb, node, node, "right") then  return true  end

	elseif nodeType == "call" then
		if node.callee and traverseTree(node.callee, leavesFirst, cb, node, node, "callee") then  return true  end
		for i, expr in ipairs(node.arguments) do
			if traverseTree(expr, leavesFirst, cb, node, node.arguments, i) then  return true  end
		end

	elseif nodeType == "function" then
		for i, name in ipairs(node.parameters) do
			if traverseTree(name, leavesFirst, cb, node, node.parameters, i) then  return true  end
		end
		if node.body and traverseTree(node.body, leavesFirst, cb, node, node, "body") then  return true  end

	elseif nodeType == "return" then
		for i, expr in ipairs(node.values) do
			if traverseTree(expr, leavesFirst, cb, node, node.values, i) then  return true  end
		end

	elseif nodeType == "block" then
		for i, statement in ipairs(node.statements) do
			if traverseTree(statement, leavesFirst, cb, node, node.statements, i) then  return true  end
		end

	elseif nodeType == "declaration" then
		for i, ident in ipairs(node.names) do
			if traverseTree(ident, leavesFirst, cb, node, node.names, i) then  return true  end
		end
		for i, expr in ipairs(node.values) do
			if traverseTree(expr, leavesFirst, cb, node, node.values, i) then  return true  end
		end

	elseif nodeType == "assignment" then
		for i, expr in ipairs(node.targets) do
			if traverseTree(expr, leavesFirst, cb, node, node.targets, i) then  return true  end
		end
		for i, expr in ipairs(node.values) do
			if traverseTree(expr, leavesFirst, cb, node, node.values, i) then  return true  end
		end

	elseif nodeType == "if" then
		if node.condition and traverseTree(node.condition, leavesFirst, cb, node, node, "condition") then  return true  end
		if node.bodyTrue  and traverseTree(node.bodyTrue,  leavesFirst, cb, node, node, "bodyTrue")  then  return true  end
		if node.bodyFalse and traverseTree(node.bodyFalse, leavesFirst, cb, node, node, "bodyFalse") then  return true  end

	elseif nodeType == "while" then
		if node.condition and traverseTree(node.condition, leavesFirst, cb, node, node, "condition") then  return true  end
		if node.body      and traverseTree(node.body,      leavesFirst, cb, node, node, "body")      then  return true  end

	elseif nodeType == "repeat" then
		if node.body      and traverseTree(node.body,      leavesFirst, cb, node, node, "body")      then  return true  end
		if node.condition and traverseTree(node.condition, leavesFirst, cb, node, node, "condition") then  return true  end

	elseif nodeType == "for" then
		for i, ident in ipairs(node.names) do
			if traverseTree(ident, leavesFirst, cb, node, node.names, i) then  return true  end
		end
		for i, expr in ipairs(node.values) do
			if traverseTree(expr, leavesFirst, cb, node, node.values, i) then  return true  end
		end
		if node.body and traverseTree(node.body, leavesFirst, cb, node, node, "body") then  return true  end

	else
		errorf("Invalid node type '%s'.", tostring(nodeType))
	end

	if leavesFirst then
		local action = cb(node, parent, container, k)
		if action == "stop"           then  return true   end
		if action == "ignorechildren" then  errorf("Cannot ignore children when leavesFirst is set.")  end
		if action                     then  errorf("Unknown traversal action '%s' returned from callback.", tostring(action))  end
	end

	return false
end
