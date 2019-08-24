-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sortLocked = false;

function setSortLock(isLocked)
	sortLocked = isLocked;
end

function onInit()
	registerMenuItem(Interface.getString("list_menu_createitem"), "insert", 5);

	onEncumbranceChanged();

	local node = getDatabaseNode();
	DB.addHandler(DB.getPath(node, "*.carried"), "onUpdate", onCarriedChanged);
	DB.addHandler(DB.getPath(node, "*.weight"), "onUpdate", onEncumbranceChanged);
	DB.addHandler(DB.getPath(node, "*.count"), "onUpdate", onEncumbranceChanged);
	DB.addHandler(DB.getPath(node), "onChildDeleted", onEncumbranceChanged);
end

function onClose()
	local node = getDatabaseNode();
	DB.removeHandler(DB.getPath(node, "*.carried"), "onUpdate", onCarriedChanged);
	DB.removeHandler(DB.getPath(node, "*.weight"), "onUpdate", onEncumbranceChanged);
	DB.removeHandler(DB.getPath(node, "*.count"), "onUpdate", onEncumbranceChanged);
	DB.removeHandler(DB.getPath(node), "onChildDeleted", onEncumbranceChanged);
end

function onMenuSelection(selection)
	if selection == 5 then
		addEntry(true);
	end
end

function onCarriedChanged(nodeCarried)
	local nodeChar = DB.getChild(nodeCarried, "....");
	if nodeChar then
		local nodeCarriedItem = DB.getChild(nodeCarried, "..");

		local nCarried = nodeCarried.getValue();
		local sCarriedItem = StringManager.trim(ItemManager.getDisplayName(nodeCarriedItem)):lower();
		if sCarriedItem ~= "" then
			for _,vItem in pairs(DB.getChildren(nodeChar, "favorlist")) do
				if vItem ~= nodeCarriedItem then
					local sLoc = StringManager.trim(DB.getValue(vItem, "location", "")):lower();
					if sLoc == sCarriedItem then
						DB.setValue(vItem, "carried", "number", nCarried);
					end
				end
			end
		end
	end
	
	onEncumbranceChanged();
end

function onEncumbranceChanged()
	if CharManager.updateEncumbrance then
		CharManager.updateEncumbrance(window.getDatabaseNode());
	end
end

function onListChanged()
	update();
	updateContainers();
end

function update()
	local bEditMode = (window.favorlist_iedit.getValue() == 1);
	window.idelete_header.setVisible(bEditMode);
	for _,w in ipairs(getWindows()) do
		w.idelete.setVisibility(bEditMode);
	end
end

function addEntry(bFocus)
	local w = createWindow();
	if w then
		if bFocus then
			w.name.setFocus();
		end
	end
	return w;
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	if not getNextWindow(nil) then
		addEntry(true);
	end
	return true;
end

function onSortCompare(w1, w2)
	if sortLocked then
		return false;
	end
	return ItemManager.onInventorySortCompare(w1, w2);
end

function updateContainers()
	ItemManager.onInventorySortUpdate(self);
end

function onDrop(x, y, draginfo)
	return ItemManager.handleAnyDrop(window.getDatabaseNode(), draginfo);
end
