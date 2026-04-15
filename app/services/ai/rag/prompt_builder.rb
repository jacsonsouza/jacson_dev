class Ai::Rag::PromptBuilder
  def call(question:, context:)
    <<~PROMPT
      You are a developer portfolio assistant.

      Use ONLY the context below:

      Context: #{context}

      Rules:
        - Do not invent information
        - Be concise
        - Answer in the user's language

      Question: #{question}
    PROMPT
  end
end
