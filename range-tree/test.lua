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

local function genTestP(size,d)
   local P = {}
   local numRange = 1000

   for i = 1,size do
      local point = {}
      for j = 1,d do
         table.insert(point,math.random(numRange))
      end
      table.insert(P,point)
   end
   return P
end


P = genTestP(100,3)
prettyPrint(P)
rt = RangeTree:new(P)

