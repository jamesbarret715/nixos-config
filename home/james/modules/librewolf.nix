{ pkgs, inputs, ... }: let 
	system = pkgs.stdenv.hostPlatform.system;
in {
	programs.librewolf = {
		enable = true;

		profiles."my-profile" = {
			isDefault = true;

			settings = {
				"browser.send_pings" = false;
				"extensions.autoDisableScopes" = 0;
				"layout.css.prefers-color-scheme.content-override" = 0;
				"network.dns.disablePrefetch" = true;
				"network.http.speculative-parallel-limit" = 0;
				"network.prefetch-next" = false;
				"privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
				"privacy.fingerPrintingProtection" = true;
				"privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
				"privacy.resistFingerprinting" = false;
				"privacy.userContext.enabled" = true;
				"privacy.userContext.ui.enabled" = true;
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
				"ui.systemUsesDarkTheme" = 1;
				"websites.hyperlinkAuditingEnabled" = false;
			};

			extensions = {
				force = true;

				packages = with inputs.firefox-addons.packages.${system}; [
					ublock-origin
					bitwarden
					darkreader
					privacy-badger
					sponsorblock
					sidebery
					firefox-color
				];	
			};

# Styling
			userChrome = ''
				* {
					border-radius: 0 !important;
				}

				#sidebar-panel-header {
					display: none;
				}

				#main-window:has(#sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"][checked="true"]) {
					#TabsToolbar > * {
						display: none !important;
					}

					#nav-bar {
						border-color: transparent !important;
					}

					#sidebar-main, #sidebar-launcher-splitter {
						display: none !important;
					}
					#sidebar-box {
						padding: 0 !important;
					}
					#sidebar-box #sidebar {
						box-shadow: none !important;
						border: none !important;
						outline: none !important;
						border-radius: 0 !important;
					}
					#sidebar-splitter {
						--splitter-width: 3px !important;
						min-width: var(--splitter-width) !important;
						width: var(--splitter-width) !important;
						padding: 0 !important;
						margin: 0 calc(-1*var(--splitter-width) + 1px) 0 0 !important;
						border: 0 !important;
						opacity: 0 !important;
					}

					/* Hide sidebar header (sidebar.revamp: false) */
					#sidebar-header {
						display: none !important;
					}
				}
				'';

			userContent = ''
				* {
					border-radius: 0 !important;
				}
			'';
		};
	};

	stylix.targets.librewolf = {
		enable = true;
		profileNames = [ "my-profile" ];
	};
}
