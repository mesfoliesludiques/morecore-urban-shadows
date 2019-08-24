-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore register "describe"
function onInit()
  CustomDiceManager.add_roll_type("describe", performAction, nil, false, "none");
end  

function performAction(draginfo, rActor, sParams)
	Debug.console("performAction: ", draginfo, rActor, sParams);
	Debug.console(sDesc);
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
end