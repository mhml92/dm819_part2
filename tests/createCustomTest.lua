I =require("inspect")

-- Read options
for i = 1,#arg do
   if arg[i] == "-n" then
      n = tonumber(arg[i+1])
      i = i + 1
   elseif arg[i] == "-d" then
      d = tonumber(arg[i+1])
      i = i + 1
   elseif arg[i] == "-r" then
      r = tonumber(arg[i+1])
      i = i + 1
   elseif arg[i] == "-s" then
      s = tonumber(arg[i+1])
      i = i + 1
   elseif arg[i] == "-rs" then
      rs = tonumber(arg[i+1])
      i = i + 1
   end
end


if not n or not d or not r or not s then

   print()
   print("Missing arguments")
   print()
   print("Option\tvalue type\tdefault\tdescription")
   print("------------------------------------------------------------")
   print("-n\t<number>\t\tsize of n, number of points")
   print("-d\t<number>\t\tnumber og dimensioins")
   print("-r\t<number>\t\tnumber og range tests to include")
   print("-s\t<number>\t\tsize of each dimension e.i the maximum coordinate value a point can have in any dimension")
   print("-rs\t<number>\trandom\tspecify the size of side in a range, e.i. -rs 300 will yeald ranges that all have side length 300")
	os.exit()
end

local function makePoint(d,s)
   local newPoint = {}
   for i = 1,d do
      table.insert(newPoint,math.random()*s)
   end
   return newPoint
end

local function makeRange(d,rs,s)
   local R = {}
   R.range = {}
   R.contains = {}
   for dim = 1,d do
      local a,b = 0,0
      if rs == nil then
         a,b = math.random()*s, math.random()*s
         local min_p,max_p = math.min(a,b),math.max(a,b)
      else
         a = math.random()*(s-rs)
         b = a + rs
      end
      table.insert(R.range, {a,b})
   end
   return R
end

--resturns a list of ranges whitch 'newPoint' intersects
local function pointInRanges(pointNumber,newPoint,Ranges)
   local intersections = {}
   for _,R in ipairs(Ranges) do
      local inRange = true
      for d,r in ipairs(R.range) do
         local r_min,r_max = r[1],r[2]
         if not (r_min <= newPoint[d] and newPoint[d] <= r_max) then
           inRange = false
           break
         end
      end
      if inRange then
         table.insert(R.contains,pointNumber)
      end
   end
end

local Ranges = {}
for i = 1,r do
 table.insert(Ranges,makeRange(d,rs,s))
end

local Points = {}
for i = 1, n do
   local newPoint = makePoint(d,s)
   pointInRanges(i,newPoint,Ranges)
   table.insert(Points,newPoint)
end

-- PRINT TAB SEP POINTS
--[[
for k,P in ipairs(Points) do
   local point = ""
   for i,p in ipairs(P.point) do
      point = point .. p .. "\t"
   end
   print(point)
end
]]

-- PRINT 
for k,P in ipairs(Points) do
   local line = ""
   for i,p in ipairs(P) do
      line = line .. p .. "\t"
   end
   print(line)
end

-- PRINT COMMA SEP RANGES
for k,R in ipairs(Ranges) do
   local range = ""
   for i,r in ipairs(R.range) do
      range = range .. r[1]..":"..r[2] .. "\t"
   end
   range = range..","
   for i,p in ipairs(R.contains) do
      range = range .. p.."\t"
   end
   print(range) 
end


