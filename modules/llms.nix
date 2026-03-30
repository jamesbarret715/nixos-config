{ ... }: {
	services.ollama = {
		enable = true;
	};

	services.open-webui = {
		enable = true;
		environment = {
			OLLAMA_BASE_URL = "http://localhost:11434";
			ENABLE_OPENAI_API = "true";
			OPENAI_API_BASE_URL = "https://api.anthropic.com/v1";
		};
	};
}

