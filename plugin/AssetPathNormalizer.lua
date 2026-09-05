local Plugin = script.Parent
local AssetPathNormalizer = {}

local function normalizePath(input)
	if typeof(input) ~= "string" then
		return nil, "Input must be a string"
	end

	local normalized = input:lower()
	normalized = normalized:gsub("^%s+", "")
	normalized = normalized:gsub("%s+$", "")
	normalized = normalized:gsub("//+", "/")

	if normalized:sub(1, 1) == "/" then
		normalized = normalized:sub(2)
	end

	if normalized:sub(-1) == "/" then
		normalized = normalized:sub(1, -2)
	end

	if normalized == "" then
		return nil, "Empty path"
	end

	local segments = {}
	for segment in normalized:gmatch("[^/]+") do
		if segment ~= "" then
			table.insert(segments, segment)
		end
	end

	if #segments == 0 then
		return nil, "No valid segments"
	end

	return table.concat(segments, "/")
end

local function validateAssetPath(path)
	local normalized, err = normalizePath(path)
	if not normalized then
		return false, err
	end

	local parts = normalized:split("/")
	if #parts < 2 then
		return false, "Path must contain at least two segments (e.g., 'game/replicatedstorage')"
	end

	local root = parts[1]
	local validRoots = { "game", "workspace", "replicatedstorage", "replicatedfirst", "serverstorage", "serverscriptservice", "soundservice", "lighting", "studioservice", "players", "coregui", "corescriptservice" }
	local isValidRoot = false
	for _, validRoot in validRoots do
		if root == validRoot then
			isValidRoot = true
			break
		end
	end

	if not isValidRoot then
		return false, "Invalid root: " .. root
	end

	return true, normalized
end

local function batchNormalize(paths)
	local results = {}
	for i, path in ipairs(paths) do
		local success, result = validateAssetPath(path)
		results[i] = {
			original = path,
			success = success,
			normalized = success and result or nil,
			error = success and nil or result
		}
	end
	return results
end

AssetPathNormalizer.normalize = normalizePath
AssetPathNormalizer.validate = validateAssetPath
AssetPathNormalizer.batchNormalize = batchNormalize

return AssetPathNormalizer
