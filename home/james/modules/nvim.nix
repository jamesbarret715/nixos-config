{ ... }: {
	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;

		colorschemes.tokyonight.enable = true;
		colorscheme = "tokyonight-storm";

		opts = {
			hlsearch = false;
			ignorecase = true;
			number = true;
			relativenumber = true;
			shiftwidth = 4;
			smartindent = true;
			tabstop = 4;
			termguicolors = true;
			undofile = true;
		};

		globals.mapleader = " ";

		plugins = {
			oil.enable = true;
			web-devicons.enable = true;
			marks.enable = true;

# Telescope
			telescope = {
				enable = true;
				extensions.ui-select.enable = true;
				settings.defaults = {
					sorting_strategy = "ascending";
					path_displays = [ "smart" ];
					layout_config = {
						horizontal = {
							prompt_position = "top";
							preview_cutoff = 40;
						};
						height = 100;
						width = 400;
					};
					borderchars = [ "" "" "" "" "" "" "" "" ];
				};
			};

# Treesitter
			treesitter = {
				enable = true;
				nixGrammars = true;
				settings.highlight.enable = true;
			};

# LSP
			lsp = {
				enable = true;
				servers = {
					basedpyright.enable = true; # Python
					clangd.enable = true;       # C/C++
					lua_ls.enable = true;    	# Lua
					nil_ls.enable = true;      	# Nix
					tinymist.enable = true;     # Typst

					rust_analyzer = { # Rust
						enable = true;
						installCargo = false;
						installRustc = false;
					};
				};
			};

# Mini Utils
			mini = {
				enable = true;
				modules = {
					ai = {};
					basics = {};
					clue = {};
					comment = {};
					completion = {};
					pairs = {};
					surround = {};
				};
			};
		};

		keymaps = [
			{ mode = "n"; key = "<leader>e"; action = "<cmd>Oil<CR>"; }
			{ mode = "n"; key = "<leader>f"; action = "<cmd>Telescope find_files<CR>"; }
			{ mode = "n"; key = "<leader>g"; action = "<cmd>Telescope live_grep<CR>"; }

# Copy to system clipboard
			{ mode = [ "n" "x" ]; key = "<leader>y"; action = "\"+y"; }

# Centering scrolls
			{ mode = "n"; key = "<C-d>"; action = "<C-d>zz"; }
			{ mode = "n"; key = "<C-u>"; action = "<C-u>zz"; }

# Swap ; and :
			{ mode = [ "n" "v" "x" ]; key = ";"; action = ":"; }
			{ mode = [ "n" "v" "x" ]; key = ":"; action = ";"; }

# jk exist INSERT
			{ mode = "i"; key = "jk"; action = "<esc>"; }
			{ mode = "i"; key = "kj"; action = "<esc>"; }
		];

	};

	stylix.targets.nixvim.enable = false;
}
