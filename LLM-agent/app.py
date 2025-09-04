# app.py
import streamlit as st
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_community.document_loaders import DirectoryLoader, PyMuPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

# ------------------------
# 1. 문서 로딩 & 벡터 스토어
# ------------------------
loader = DirectoryLoader(
    "./data/",
    glob="Friends*.pdf",   # Friends*.pdf 파일만 로딩
    loader_cls=PyMuPDFLoader
)
docs = loader.load()

text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=400,
    chunk_overlap=50,
)
splits = text_splitter.split_documents(docs)

embedding = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(documents=splits, embedding=embedding)
retriever = vectorstore.as_retriever(search_kwargs={"k": 2})

# ------------------------
# 2. Streamlit UI
# ------------------------
st.title("📺 Friends 영어 선생님 QA")
st.write("한국어로 질문을 입력하면, 관련된 영어 대사와 번역을 보여줍니다!")

user_question = st.text_input("👉 한국어로 질문을 입력하세요:")

if user_question:
    results = retriever.get_relevant_documents(user_question)

    # 🔹 문장 여러 개를 합쳐서 한 번만 LLM 호출
    combined_text = "\n".join([doc.page_content for doc in results])

    prompt = f"""
너는 Friends를 좋아하는 친절한 영어 선생님이야.
아래 대사들을 영어 원문과 한국어 번역 쌍으로 보여줘.
형식:
영어 [대사]
한국어 [번역]

마지막에는 중요한 영어 표현을 짧게 설명해줘.

대사:
{combined_text}
    """

    llm = ChatOpenAI(model="gpt-4.1-mini", temperature=0)

    st.subheader("결과:")
    # 🔹 스트리밍 출력
    with st.spinner("번역 중..."):
        response_container = st.empty()
        full_text = ""
        for chunk in llm.stream(prompt):
            full_text += chunk.content
            response_container.markdown(full_text)