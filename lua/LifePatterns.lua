
--- Insert a given pattern in a CellularSpace.
-- @arg cs1 A CellularSpace to receive the pattern.
-- @arg cs2 A CellularSpace with the pattern.
-- @arg x0 The x position where the pattern will be copied on the CellularSpace.
-- @arg y0 The y position where the pattern will be copied on the CellularSpace.
-- @usage import("ca")
--
-- cs = CellularSpace{xdim = 10}
-- insertPattern(cs, getLife("glider"), 0, 0)
function insertPattern(cs1, cs2, x0, y0)
	for i = 0, (cs2.ydim - 1) do
		for j = 0, (cs2.xdim - 1) do
			cs1:get(x0 + j, y0 + i).state = cs2:get(j, i).state
		end
	end
end

--- Return a CellularSpace from a data file available in the ca package.
-- It works with .life files, where the CellularSpace is stored as spaces
-- (dead) or Xs (alive).
-- @arg pattern A string with a file name without .file.
-- @usage import("ca")
--
-- glider = getLife("glider")
function getLife(pattern)
	local mfile = filePath(pattern..".life", "ca")

	local lines = {}
	local mline = mfile:readLine()

	repeat
		table.insert(lines, mline)
		mline = mfile:readLine()
	until not mline

	local xdim = string.len(lines[1])
	local ydim = #lines

	if ydim == xdim then ydim = nil end

	local cs = CellularSpace{
		xdim = xdim,
		ydim = ydim
	}

	forEachElement(lines, function(y, line)
		if xdim ~= string.len(line) then
			customError("Line "..y.." of file '"..pattern.."' does not have the same length ("
				..string.len(line)..") of the first line ("..xdim..").")
		end

		for x = 1, xdim do
			if string.sub(line, x, x) == "X" then
				cs:get(x - 1, y - 1).state = "alive"
			elseif string.sub(line, x, x) == " " then
				cs:get(x - 1, y - 1).state = "dead"
			else
				customError("Invalid character '"..string.sub(line, x, x)
					.."' in file '"..pattern.."' (line "..y..").")
			end
		end
	end)

	return cs
end

