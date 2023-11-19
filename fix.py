from autogen.agentchat.contrib.retrieve_assistant_agent import RetrieveAssistantAgent
from autogen.agentchat.contrib.retrieve_user_proxy_agent import RetrieveUserProxyAgent

llm_config = {
    "request_timeout": 600,
    "config_list": config_list,
    "temperature": 0
}


interface = autogen_interface.AutoGenInterface()
persistence_manager=InMemoryStateManager()
persona = "I am a strategic analyst, trained in cyber security. I worked for the NSA."
human = "Im a team manager at this company"
memgpt_agent=presets.use_preset(presets.DEFAULT_PRESET, model='gpt-4', persona=persona, human=human, interface=interface, persistence_manager=persistence_manager, agent_config=llm_config)


if not USE_MEMGPT:
    # In the AutoGen example, we create an AssistantAgent to play the role of the coder
    assistant = RetrieveAssistantAgent(
        name="assistant",
        system_message="You are a helpful assistant.",
        human_input_mode="TERMINATE",
        llm_config=llm_config,
        human_input_mode="TERMINATE",
    )

else:
    # In our example, we swap this AutoGen agent with a MemGPT agent
    # This MemGPT agent will have all the benefits of MemGPT, ie persistent memory, etc.
    print("\nMemGPT Agent at work\n")
    coder = memgpt_autogen.MemGPTAgent(
        name="MemGPT_assistant",
        agent=memgpt_agent,
    )






rag_agent = RetrieveUserProxyAgent(
    human_input_mode="NEVER",
    retrieve_config={
        "task": "qa",
        "docs_path": "/content/drive/MyDrive/ColabDataSets/shaydocs",
        "collection_name": "rag_collection",
        "embedding_function": openai_embedding_function,
        "custom_text_split_function": text_splitter.split_text,
        "get_or_create": True,
        "max_consecutive_auto_reply": 10
    },
)
