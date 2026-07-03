local function guess_base_branch(default)
	local cmd =
		[[git show-branch -a 2>/dev/null | grep '\*' | grep -v "\[$(git rev-parse --abbrev-ref HEAD)\]" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//']]
	local ok, result = pcall(vim.fn.system, { "bash", "-c", cmd })
	if not ok then
		return default
	end

	result = vim.trim(result or "")
	if result == "" then
		return default
	end

	result = result:gsub("^remotes/", "")

	-- Only strip a leading "<remote>/" if <remote> is an actual configured remote,
	-- so branch names like "bug/fix-critical-message" are left alone.
	local remotes_out = vim.fn.system("git remote")
	for remote_name in remotes_out:gmatch("[^\r\n]+") do
		local prefix = "^" .. vim.pesc(remote_name) .. "/"
		if result:match(prefix) then
			result = result:gsub(prefix, "")
			break
		end
	end

	return result
end
return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope.nvim", -- optional, but nice for pickers
	},
	config = function()
		require("octo").setup()

		local utils = require("octo.utils")
		local orig_get_repo_info = utils.get_repo_info
		utils.get_repo_info = function(repo)
			local info = orig_get_repo_info(repo)
			if info and info.defaultBranchRef and info.defaultBranchRef.name then
				local base = guess_base_branch(info.defaultBranchRef.name)
				if base ~= info.defaultBranchRef.name then
					info = vim.deepcopy(info) -- don't mutate octo's internal cache
					info.defaultBranchRef.name = base
				end
			end
			return info
		end
	end,
}
