--- Copyright © 2026, YourLocalCappy, all rights deserved ---

local type = type

function ToPanel( pPanel )
  if ( not pPanel or type( pPanel ) ~= "panel" ) then
    return INVALID_PANEL;
  end

  local success, hPanel = pcall( _R.Panel.GetVPanel, pPanel )
  if ( not success ) then
    hPanel = INVALID_PANEL
  end
if _DEBUG then
  assert( hPanel ~= INVALID_PANEL );
end

  return hPanel;
end
