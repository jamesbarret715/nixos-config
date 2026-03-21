{ pkgs, ... }: {
	programs.television = {
		enable = true;
		enableZshIntegration = true;

		channels = {
			applications = {
				metadata = {
					name = "applications";
					description = "Fuzzy search installed applications";
				};

				source = {
					command = pkgs.writeShellScript "applications-source" ''
						sed -E "s.(:|$)./applications .g" <<< "$XDG_DATA_DIRS" | \
						xargs ${pkgs.fd}/bin/fd -e desktop . 2>/dev/null | \
						while read -r entry; do 
							${pkgs.yq-go}/bin/yq -p=ini -o=csv '.["Desktop Entry"] | [.Name, .Exec, .Hidden // false]' "$entry" | \
							sed -E "s/\s?%\w//g" | \
							grep false
						done
					'';

					display = "{split:,:0}";
					output = "{split:,:1}";
				};

				ui = {
					input_header = "Applications:";
					input_prompt = ">> ";

					preview_panel.hidden = true;
					status_bar.hidden = true;
					help_panel.disabled = true;
					remote_control.disabled = true;
				};
			};
		};
	};
}

