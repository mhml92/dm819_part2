if not tonumber(arg[1])  then
	print("test_size\tdimension\tmax\tmin\tnum_of_range_test\trange_num_elements")
	os.exit()
end

I =require("kdtree.inspect")

--inputs
for i=1,#arg do 
	arg[i] = tonumber(arg[i])
end

local test_size = arg[1]
local dimension = arg[2]
local max = arg[3]
local min = arg[4]

local num_of_range_tests = arg[5]
local range_num_elements = arg[6]

--random function
math.randomseed(os.time())
local rand = function(mi,ma) return math.random(mi or min,ma or max) end

--deepcopy
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

--select interval
local function select(list, k)
	local list = deepcopy(list)
	for i=1,k do
		local minIndex = i
		local minValue = list[i]
		for j=i+1,#list do
			if list[j] < minValue then
				minIndex = j
				minValue = list[j]
			end
		end
		list[i],list[minIndex] = list[minIndex],list[i] --swap
	end
	return list[k]
end


local R = {}

local MAX_POINTS = range_num_elements 

local buffer = (max-min) * 0.1

--print("Max " .. max, "Min " .. min)

local function makeRange(d)
	local r = {}
	for i=1,d do
		local start = rand(min+buffer,max-buffer)

		r[i] = {start,start+buffer}
	end

	return r
end

local allPoints = {}

local function pointInRange(p)
	list_of_ranges = {}
	for k,r in ipairs(R) do
		local inside = true
		for d=1,dimension do
			if r.range[d][1] > p[d] or r.range[d][2] < p[d] then
				inside = false
				break
			end
		end

		if inside then
			table.insert(list_of_ranges, k)
		end
	end

	for k,v in ipairs(list_of_ranges) do
		if #R[v].list_of_points == MAX_POINTS then
			return false
		end
	end

	local allSame = true 
	if #allPoints == 0 then 
		allSame = false
	end

	for i=1,#allPoints do
		allSame = true
		for d=1,dimension do
			if allPoints[i][d] ~= p[d] then
				allSame = false
				break
			end
		end
		if allSame == true then
			break
		end
	end

	if allSame then
		return false
	end

	for k,v in ipairs(list_of_ranges) do
		table.insert(R[v].list_of_points, p)
	end


	table.insert(allPoints, p)

	return true
end

local function createPointInRange(r)
	local p = {}
	for d=1,dimension do
		p[d] = rand(r.range[d][1],r.range[d][2])
	end
 	return p
end


--print("num_of_range_tests", num_of_range_tests)

for i=1,num_of_range_tests do
	table.insert(R, {range = makeRange(dimension), list_of_points = {} })
end

print("MAX POINTS " .. MAX_POINTS)
--print("#R " .. #R)
for index=1, #R do 
	while #R[index].list_of_points < MAX_POINTS do
		local p = createPointInRange(R[index])
		if pointInRange(p) then
			print("INDEX ["..index.."] "..I(p))
		else
			print("INDEX ["..index.."] ".."NOT POSSIBLE " ..I(p) .. " #allPoints "..#allPoints)
		end
	end
end

local AllRange = {range={}}

for d=1,dimension do
	AllRange.range[d] = {min,max}
end

--print(#allPoints .. " < " .. test_size)

while #allPoints < test_size do
	local p =  createPointInRange(AllRange)
	if pointInRange(p) then
		--print("ADDED POINT " .. I(p))
	else
		--print("POINT WAS IN A RANGE " .. I(p))
	end
end

for i=1,test_size do
	for j=1,dimension do
		io.write(allPoints[i][j])
		if not (j == dimension) then
			io.write("\t")
		end
	end
	io.write("\n")
end

for i=1,#R do
	for j=1,dimension do
		io.write(R[i].range[j][1]..":"..R[i].range[j][2])
		if not (j == dimension) then
			io.write("\t")
		end
	end
	io.write("\n")
end


