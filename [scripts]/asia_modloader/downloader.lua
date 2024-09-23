local txd = engineLoadTXD ( "objects/items/safe.txd" )
engineImportTXD ( txd, 2332,1829 )
local dff = engineLoadDFF ( "objects/items/safe.dff" )
engineReplaceModel ( dff, 2332 )
local dff = engineLoadDFF ( "objects/items/safe_destroyed.dff" )
engineReplaceModel ( dff, 1829 )
local col = engineLoadCOL("objects/items/safe.col");
engineReplaceCOL(col, 2332, 1829);

local txd = engineLoadTXD ( "objects/items/3243.txd" )
engineImportTXD ( txd, 3243 )
local dff = engineLoadDFF ( "objects/items/3243.dff" )
engineReplaceModel ( dff, 3243 )
local col = engineLoadCOL("objects/items/3243.col");
engineReplaceCOL(col, 3243);

local mapobjects = {
  {"ang",2296},
  {"baguilok",2297},
  {"bigsandbags",2298},
  {"baraquement",2299},
  {"controltower",2300},
  {"fire",2301},
  {"fires",2302},
  {"medictent",2303},
  {"tents",2304},
  {"tents2",2305},
  {"torre",3279},
  {"vaz2105",12957},
  {"carlom2",3594},
  {"carlom11",3593},
}

addEventHandler("onClientResourceStart",resourceRoot,function()
  for i,v in pairs(mapobjects) do
    local col11 = engineLoadCOL("objects/map/"..v[1]..".col")
    engineReplaceCOL(col11,v[2]);
    local txd11 = engineLoadTXD("objects/map/"..v[1]..".txd");
    engineImportTXD (txd11,v[2]);
    local dff11 = engineLoadDFF("objects/map/"..v[1]..".dff");
    engineReplaceModel(dff11,v[2]);
    engineSetModelLODDistance(v[2], 1000);
  end
end);