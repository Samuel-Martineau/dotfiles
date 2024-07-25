{ pkgs, ... }:
{
  home.persistence.default.files = [
    ".mozilla/firefox/dev-edition-default/cookies.sqlite"
    ".mozilla/firefox/dev-edition-default/cookies.sqlite-wal"
    ".mozilla/firefox/dev-edition-default/storage.sqlite"
  ];
  
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;

    policies = {
      NewTabPage = true;
      DisableFirefoxAccounts = true;
      DisableAppUpdate = true;
      CaptivePortal = false;
      DNSOverHTTPS.Enabled = false;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisablePocket = true;
    };

    profiles.dev-edition-default = {
      extensions = [
        pkgs.nur.repos.rycee.firefox-addons.privacy-badger
        pkgs.nur.repos.rycee.firefox-addons.kagi-search
        (pkgs.callPackage ./addons/multi-account-containers.nix { })
      ];

      settings = {
        "extensions.autoDisableScopes" = 0;
        "xpinstall.signatures.required" = false;
      };

      extraConfig = builtins.readFile ./ffprofile.com.js;

      containers = {
        "Personnel" = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        "École" = {
          color = "turquoise";
          icon = "briefcase";
          id = 2;
        };
      };
      containersForce = true;

      bookmarks = [
        {
          name = "Toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "Akin's Laws of Spacecraft Design";
              url = "https://spacecraft.ssl.umd.edu/akins_laws.html";
            }
            {
              name = "GitHub";
              url = "https://github.com";
            }
            {
              name = "Hacker News";
              url = "https://news.ycombinator.com";
            }
            {
              name = "XKCD";
              url = "https://xkcd.com";
            }
          ];
        }
      ];

      search = {
        engines = {
          "Google".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
          "DuckDuckGo Lite".metaData.hidden = true;
          "SearXNG - searx.be".metaData.hidden = true;
          "MetaGer".metaData.hidden = true;
          "StartPage".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "Amazon.ca".metaData.hidden = true;
          "eBay".metaData.hidden = true;
          "Qwant".metaData.hidden = true;
        };
        force = true;
        default = "Kagi";
      };
    };
  };

  home.file.".mozilla/firefox/dev-edition-default/extension-preferences.json".text = ''
    {
      "search@kagi.com": {
        "permissions": [
          "internal:privateBrowsingAllowed"
        ],
        "origins": [
          "https://kagi.com/*"
        ]
      }
    }
  '';
}
