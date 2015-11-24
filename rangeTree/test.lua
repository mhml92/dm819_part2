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

function stringSplit(inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={} ; i=1
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
   end
   return t
end

local function isPointInRange(point,range) 
   for rpi,rp in ipairs(range) do
      for i,e in ipairs(rp) do
         if e == point[i] then
            return true
         end
      end
   end
   return false
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
   
   local fileName = stringSplit(inputfile,"/")
   fileName = fileName[#fileName]

   P = {}
   R = {}
   RESULTS = {}
   -- read input
   for l in io.lines(inputfile) do
      if l ~= "" then
         if string.match(l, ":") then
            local r = {}
            -- if test contains results
            if string.match(l,",") then
               local res = {}
               local rangeANDresult = {}
               for elem in string.gmatch(l,"[^,]*") do
                  if elem ~= "" then
                     table.insert(rangeANDresult,elem)
                  end
               end
               l = rangeANDresult[1]
               if rangeANDresult[2] then
                  for pointNum in string.gmatch(rangeANDresult[2],"[^\t]*") do
                     if pointNum ~= "" then
                        table.insert(res,pointNum)
                     end
                  end
               end
               table.insert(RESULTS,res)
            end
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
         collectgarbage("collect")
      measures.memory = collectgarbage("count")/1024
      measures.querys = {}
      for k,r in ipairs(R) do
         measures.querys[k] = {}
         local q = measures.querys[k]
         q.t1 = os.clock()
         local res = rt:findPointsInRange(r)
         q.t2 = os.clock()
         q.outSize = #res
         q.correct = true
         for i,pointIndex in ipairs(RESULTS[k]) do
            if not isPointInRange(P[tonumber(pointIndex)],res) then
               q.correct = false
            end
         end
      end
      print("alg\tfile\tn\toutputSize\tcorrect\tbuildTime\tsearchTime\tmemory\tdim") 
      for k,v in ipairs(measures.querys) do
         print("rangeTree\t"..fileName.."\t"..measures.n.."\t"..v.outSize.."\t".. tostring(v.correct) .."\t"..measures.build_t2-measures.build_t1.."\t"..v.t2-v.t1 .. "\t" .. measures.memory .. "\t" .. #P[1])
      end
   else
      local rt = RangeTree:new(P)
      local res = {}
      for k,r in ipairs(R) do
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

