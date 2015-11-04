if not tonumber(arg[1])  then
	print("test_size\tdimension\tmax\tmin\tnum_of_range_test\trange_num_elements")
	os.exit()
end


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

local dims = {}
for i=1,dimension do
	dims[i] = {}
end
for i=1,test_size do
	for j=1,dimension do
		local r = rand()
		io.write(r)
		table.insert(dims[j], r)
		if not (j == dimension) then
			io.write("\t")
		end
	end
	io.write("\n")
end

print("")

local interval = test_size - range_num_elements
for i=1,num_of_range_tests do
	for j=1,dimension do
		local min = rand(1,interval)
		local max = min + range_num_elements
		min = select(dims[j], min)
		max = select(dims[j], max)

		io.write(min..":"..max)
		if not (j == dimension) then
			io.write("\t")
		end
	end
	io.write("\n")
end

