
function deepcopy(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
         copy[self:deepcopy(orig_key)] = self:deepcopy(orig_value)
      end
      setmetatable(copy, self:deepcopy(getmetatable(orig)))
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
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

for _,r in ipairs(R) do

   

   p = deepcopy(P)
   table.sort(P,function(a,b) 
      local l = 1 
      while a[l] == b[l] and l < #a do
         l = l + 1
      end
      return a[l] < b[l]
   end)

   for _,v in ipairs(p) do
      
   end

end
