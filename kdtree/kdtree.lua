local I = require("inspect")

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


--https://en.wikipedia.org/wiki/Selection_algorithm
local function select(list, k, dimension)
	local list = deepcopy(list)
	for i=1,k do
		local minIndex = i
		local minValue = list[i][dimension]
		for j=i+1,#list do
			if list[j][dimension] < minValue then
				minIndex = j
				minValue = list[j][dimension]
			end
		end
		list[i],list[minIndex] = list[minIndex],list[i] --swap
	end
	return list[k][dimension]
end

local function splitListOnMedian(list,dimension)
	local halv = math.ceil(#list/2)
	local median = select(list,halv, dimension)
	local p1,p2 = {},{}

	for k,v in ipairs(list) do
		if v[dimension] <= median then
			table.insert(p1,v)
		else
			table.insert(p2,v)
		end
	end
	return p1,p2,median
end

local function createNode(val, left, right)
	return {val=val, left=left, right=right}
end

--?d kd-tree
local function BUILDKDTREE(P,depth,dimension)
	local P = deepcopy(P)
	if #P == 0 then
		return nil
	end
	if #P == 1 then --contains only one point
		return createNode(P[1])
	else 
		local d = (depth % dimension)+1
		local p1,p2,median = splitListOnMedian(P,d)

		return createNode(median, BUILDKDTREE(p1, depth+1, dimension), BUILDKDTREE(p2, depth+1,dimension))
	end
end

local function CHECKINRANGE(v, R)
	for k,val in ipairs(v) do

		--if one of the values doesn't match
		if not( R[1][k] <= val and R[2][k] >= val ) then
			return false		
		end
	end
	return true
end

local function INTERSECTION(R, region)
	for i=1,#R[1] do
		--if they aren't set, we need to check further down
		if not (region[1][i] or region[2][i]) then
			return true
		end
		if (R[1][i] <= region[1][i] and region[1][i] <= R[2][i]) or 
		   (R[1][i] <= region[2][i] and region[2][i] <= R[2][i]) then
			return true
		end	
	end
	return false
end

local function REGION(halfline, d, region, orientation)
	local region = deepcopy(region)

	if orientation == "left" then
		region[2][d] = halfline
	else
		region[1][d] = halfline
	end

	return region
end

local function FULLYCONTAINED(R, region)
	for i=1,#R[1] do
		if not (region[1][i] and R[1][i] <= region[1][i] and 
			    region[2][i] and R[2][i] >= region[2][i]) then
			return false
		end	
	end
	print("FULLY REGION ::: " ..I(region))
	return true
end

--initiate pointers to reports and function
local reports, reportfunc = {}, function () end

local function SEARCHKDTREE(v, R, region, depth)
	if v == nil then
		return
	end
	--default values
	local depth = depth or 0
	local region = region or {{},{}}

	--#R[1] == dimension of R
	
	if v.left == nil and v.right == nil then
		if CHECKINRANGE(v.val, R) then 
			print("REPORTED MOTHERFUCKER " .. I(v.val)) --should be reported
			reportfunc(v)
		end
	else
		local d = (depth % #R[1])+1

		local lregion = REGION(v.val, d, region, "left")
		if FULLYCONTAINED(R, lregion) then
			print("REPORTED FULLY CONTAINED !!!! ... " ..I(v.left)) --report whole left tree
			reportfunc(v.left)
		else
			if INTERSECTION(R, lregion) then
				SEARCHKDTREE(v.left, R, lregion, depth+1)
			else
				print("NOT INTERSECTION" .. I(v))
			end
		end

		local rregion = REGION(v.val, d, region, "right")
		if FULLYCONTAINED(R, rregion) then
			print("REPORTED FULLY CONTAINED !!!! ... " ..I(v.right)) --report whole left tree
			reportfunc(v.right)
		else
			if INTERSECTION(R, rregion) then
				SEARCHKDTREE(v.right, R, rregion, depth+1)
			else
				print("NOT INTERSECTION" .. I(v))
			end
		end
	end
end


local function INITKDSEARCH(tree, R, region)
	--change pointers
	reports = {}
	local function REPORTSUBTREE(v)
		if v.left == nil and v.right == nil then
			table.insert(reports, v.val)
		else
			if v.left then
				REPORTSUBTREE(v.left)
			end
			if v.right then
				REPORTSUBTREE(v.right)
			end
		end
	end
	reportfunc = REPORTSUBTREE

	SEARCHKDTREE(tree, R, region)

	return reports
end

local function naiveMaxMinRegion(list)
	local region = {{},{}}

	local max,min = math.max,math.min

	for _,node in ipairs(list) do
		for d,v in ipairs(node) do
			if not region[1][d] then region[1][d] = v end
			if not region[2][d] then region[2][d] = v end

			region[1][d] = min(region[1][d],v)
			region[2][d] = max(region[2][d],v)
		end
	end

	return region
end

--list = {{1,2},{2,3},{3,4},{4,5},{5,6}}
list = {{1,1},{9,9},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{2,2},{10,10}}

print("NAIVE LIST" , I(naiveMaxMinRegion(list)))

local tree = BUILDKDTREE(list,0,2)
--print(I(tree))

local R = {{1,1},{10,10}}

print(I(tree))

print(I(INITKDSEARCH(tree, R, naiveMaxMinRegion(list))))
