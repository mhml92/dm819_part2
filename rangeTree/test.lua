local RangeTree = require "RangeTree"
local I = require "inspect"
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
-- Make own test input
if(#arg == 0) then
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
else
   local performanceTest = false
   local inputfile = ""
   for k,v in ipairs(arg) do
      if v == "-R" then
         performanceTest = true
      else
         inputfile = v
      end
   end

   P = {}
   R = {}
   -- read input
   for l in io.lines(inputfile) do
      if l ~= "" then
         if string.match(l, ":") then
            local r = {}
            for elem in string.gmatch(l,"[^\t]*") do
               if elem ~= "" then
                  local tmp ={}
                  for part in string.gmatch(elem,"[^:]*") do
                     if part ~= "" then
                        table.insert(tmp,part)
                     end
                  end
                  table.insert(r,{min = tonumber(tmp[1]),max = tonumber(tmp[2])})
               end
            end
            table.insert(R,r)
         else
            local point = {}
            for elem in string.gmatch(l,"[^\t]*") do
               if elem ~= "" then
                  table.insert(point,tonumber(elem))
               end
            end
            table.insert(P,point)
         end
      end
   end

   if performanceTest then
      local measures = {}
      measures.n = #P
      measures.build_t1 = os.clock()
      local rt = RangeTree:new(P)
      measures.build_t2 = os.clock()
      measures.querys = {}
      for k,r in ipairs(R) do
         measures.querys[k] = {}
         local q = measures.querys[k]
         q.t1 = os.clock()
         local res = rt:findPointsInRange(r)
         q.t2 = os.clock()
         q.outSize = #res
      end
      print("alg\tn\toutputSize\tbuildTime\tsearchTime") 
      for k,v in ipairs(measures.querys) do
         print("rangeTree\t"..measures.n.."\t"..v.outSize.."\t"..measures.build_t2-measures.build_t1.."\t"..v.t2-v.t1)
      end
   else
      local rt = RangeTree:new(P)
      local res = {}
      for k,r in ipairs(R) do
      print("-----------------------------------")
         local result = rt:findPointsInRange(r)
         table.insert(res,result)
      end
      for k,v in ipairs(res) do
         for k1,v1 in ipairs(v) do
            local strPoint = ""
            for k2,v2 in ipairs(v1) do
               strPoint = strPoint .. v2 .. "\t" 
            end
            print(strPoint)
         end
         print()
      end
   end
end

