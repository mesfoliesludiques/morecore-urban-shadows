--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onClickDown()
  local sIcon = getStringValue();
  
  setIcon("down");  

  return true;
end

function onHoverUpdate()
  updateDisplay();
end

function onClickRelease()

  updateDisplay();
  
  sIcon = "button_link";
  local sCurrentId = User.getCurrentIdentity();
--  Debug.console("sCurrentId1: ", sCurrentId);

  if sCurrentId then
    sIcon = "portrait_" .. sCurrentId .. "_chat";
  end

--  Debug.console("portrait_token: ", sIcon);
--  Debug.console("sCurrentId: ", sCurrentId);


  local cli_rollsWindowDBNode = window.getDatabaseNode();
  local cli_rollsListDBNode = window.getDatabaseNode().getParent();
  local charSheetDBNode = window.getDatabaseNode().getParent().getParent();
  local rActor = ActorManager.getActor("pc", charSheetDBNode);
--  Debug.console("rActorMCR: ", rActor);
  local nodeWin = cli_rollsWindowDBNode;
--  Debug.console("nodeWin: ", nodeWin);
  local myCliName = nodeWin.getChild("name").getValue();
--  Debug.console("myCliName: ", myCliName);

  if nodeWin.getChild("clichatcommand")  == nil then
--    Debug.console("No command");
    local sMydesc = nodeWin.getChild("name").getValue();
--    Debug.console("sMydesc: ", sMydesc);
    local sRollName = nodeWin.getChild("name").getValue();
--    Debug.console("sRollName: ", sRollName);
    local msg = {font = "msgfont", icon = sIcon };
    msg.text = rActor.sName .. " uses " .. sRollName;
--    Debug.console("msg: ", msg.text);
--	Debug.console(msg.text);
    Comm.deliverChatMessage(msg);

  else

    local command = nodeWin.getChild("clichatcommand").getValue();
	local formulaEnabled = nodeWin.getChild("parameter_formula_enabled").getValue();	
	if( formulaEnabled == 1 ) then
		command = ParameterManager.updateCommand(nodeWin);
	end
	
--    Debug.console("command: ", command);

    if command ~= "" then

      local myCliCommand = nodeWin.getChild("clichatcommand").getValue();
--      Debug.console("myCliCommand: ", myCliCommand);

      local nStart,nEnd,sCommand,sParams = string.find(command, '^/([^%s]+)%s*(.*)');

      local sMydesc = nodeWin.getChild("name").getValue();
--      Debug.console("sMydesc: ", sMydesc);

      if sCommand == "rollon" then
        sParams = sParams;
--        Debug.console("Rollon!: ", sParams);
      else
        sParams = sParams .." "..sMydesc;
--        Debug.console("Other!: ", sParams);
      end


--      Debug.console("sCommand3: ",sCommand, sParams);
      local sRollName = nodeWin.getChild("name").getValue();
      local sRollDesc = nodeWin.getChild("description").getText();
--      Debug.console("sRollName: ", sRollName);
      local msg = {font = "msgfont", icon = sIcon };
      msg.text = rActor.sName .. " uses " .. sRollName;

--      Debug.console("launching command: ", sCommand, nil, rActor, sParams);

      if CustomDiceManager.rollRegistered(sCommand) then
        CustomDiceManager.performAction(sCommand, nil, rActor, sParams);
      else
--        Debug.console("launching command: ", sCommand, sParams);
        if sCommand == "die" then
          ChatManager.processDie(sCommand, sParams);
        elseif sCommand == 'successes' and CountSuccesses then
          CountSuccesses.processRoll(sCommand, sParams);
        elseif sCommand == 'cstun' and CStun then
          CStun.processRoll(sCommand, sParams);
        elseif sCommand == 'ckill' and CKill then
          CKill.processRoll(sCommand, sParams);
        elseif sCommand == 'rollunder' and RollUnder then
          RollUnder.processRoll(sCommand, sParams);
        elseif sCommand == 'rollunderdmod' and RollUnderDMod then
          RollUnder.processRoll(sCommand, sParams);
        elseif sCommand == 'rollundersmod' and RollUnderSMod then
          RollUnder.processRoll(sCommand, sParams);
        elseif sCommand == 'rollover' and RollOver then
          RollOver.processRoll(sCommand, sParams);
        elseif sCommand == 'conan' and Conan then
          Conan.processRoll(sCommand, sParams);
        elseif sCommand == 'coriolis' and Coriolis then
          Coriolis.processRoll(sCommand, sParams);
        elseif sCommand == 'sfdice' and SuccessFail then
          SuccessFail.processRoll(sCommand, sParams);

        elseif sCommand == 'mod' then
--          Debug.console("Modifier!", sCommand);
--          Debug.console("Modifier!!", sParams);
          ChatManager.processMod(sCommand, sParams);
        elseif sCommand == 'rollon' then
--          Debug.console("Rollon!", sCommand);
--          Debug.console("Rollon!!", sParams);
          TableManager.processTableRoll(sCommand, sParams);
        elseif sCommand == 'woddice' and WODdice then
          WODdice.processRoll(sCommand, sParams);
        elseif sCommand == 'rnk' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'rnkd' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepDamageSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'rnkdk' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepDamageKatanaSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'rnke' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepEmphasisSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'edie' and DiceMechanicsManager then
          DiceMechanicsManager.onExplodingDiceSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'edies' and DiceMechanicsManager then
          DiceMechanicsManager.onExplodingDiceSuccessesSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'spell' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'cleric' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'wizard' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'druid' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'bard' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'skull' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'trait' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'mtrait' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'ability' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'btalent' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'btechnique' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'describe' then
          local msg = {font = "msgfont", icon = sIcon };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
          msg.icon = nil;
          msg.mode = "story";
          msg.font = "storyfont";
          msg.text = sRollDesc;
          Comm.deliverChatMessage(msg);
        end
      end

    elseif command == "" then
--      Debug.console("No command");
      local sMydesc = nodeWin.getChild("name").getValue();
--      Debug.console("sMydesc: ", sMydesc);
      local sRollName = nodeWin.getChild("name").getValue();
--      Debug.console("sRollName: ", sRollName);
      local msg = {font = "msgfont", icon = sIcon };
      msg.text = rActor.sName .. " uses " .. sRollName;
--      Debug.console("msg: ", msg.text);
--      Debug.console(msg.text);
      Comm.deliverChatMessage(msg);

    end
  end
end