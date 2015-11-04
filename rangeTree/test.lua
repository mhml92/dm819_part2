local RangeTree = require "RangeTree"

local function prettyPrint(P)
   for k,v in ipairs(P) do
      str = ""
      for i = 1,#v do
         str = str .. string.format("%4d",v[i]) .. " " 
      end
      print(str)
   end
end

local function genTestP(size,d,numRange)
   local P = {}
   math.randomseed(os.time())
   for i = 1,size do
      local point = {}
      for j = 1,d do
         table.insert(point,math.random(numRange))
      end
      table.insert(P,point)
   end
   return P
end

local numRange = 100

local P = genTestP(10,3,numRange)
print("Input:")
prettyPrint(P)
R = {
   {min= 0,max= 50},
   {min= 0,max= 100},
   {min= 0,max= 100}
}
print("Range:")
for k,v in ipairs(R) do
   s = ""
      s = s .. string.format("%4d",v.min) .. " ".. string.format("%4d",v.max)
   print(s)
end
print("Start")
local rt = RangeTree:new(P)
rt:NDRangeQuery(rt.T,R,1)
print("Result:")
for k,v in ipairs(rt.result) do
   s = ""
   for k1,v1 in ipairs(v) do
      s = s .. string.format("%4d",v1) .. " "
   end
   print(s)
end


