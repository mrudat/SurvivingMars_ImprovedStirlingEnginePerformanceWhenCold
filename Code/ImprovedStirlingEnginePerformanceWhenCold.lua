local orig_print = print
if Mods.mrudat_TestingMods then
  print = orig_print
else
  print = empty_func
end

local CurrentModId = rawget(_G, 'CurrentModId') or rawget(_G, 'CurrentModId_X')
local CurrentModDef = rawget(_G, 'CurrentModDef') or rawget(_G, 'CurrentModDef_X')
if not CurrentModId then

  -- copied shamelessly from Expanded Cheat Menu
  local Mods, rawset = Mods, rawset
  for id, mod in pairs(Mods) do
    rawset(mod.env, "CurrentModId_X", id)
    rawset(mod.env, "CurrentModDef_X", mod)
  end

  CurrentModId = CurrentModId_X
  CurrentModDef = CurrentModDef_X
end

orig_print("loading", CurrentModId, "-", CurrentModDef.title)

function StirlingGenerator:UpdateFrozen()
  local modifier = 0
  if self:IsFreezing() then
    modifier = self.penalty_pct
  end

  self:SetModifier("electricity_production", "CfMrNOp", 0, modifier, "Increased Performance In The Cold")
end

function OnMsg.ClassesPreprocess()
  local StirlingGenerator = StirlingGenerator

  local StirlingGenerator_parents = StirlingGenerator.__parents

  if table.find(StirlingGenerator_parents, "ColdSensitive") then
    return
  end

  StirlingGenerator_parents[#StirlingGenerator_parents+1] = "ColdSensitive"

  local StirlingGenerator_BuildingUpdate = StirlingGenerator.___BuildingUpdate
  StirlingGenerator_BuildingUpdate[#StirlingGenerator_BuildingUpdate+1] = StirlingGenerator.UpdateFrozen

  StirlingGenerator.freeze_progress = 0
  -- dbl water tanks
  StirlingGenerator.freeze_time = 999 * 2
  StirlingGenerator.defrost_time = 999
end

orig_print("loaded", CurrentModId, "-", CurrentModDef.title)
