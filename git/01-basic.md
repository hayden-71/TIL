### git init
현재 폴더를 **저장소(리포)** 로 만든다.

### commit 사용자 정보 설정
git config --global user.name "ㅇㅇㅇ"

git config --global user.email "a.gmail.com"

--global은 전역 설정. 이 컴퓨터의 모든 Git 저장소에 적용 됨

git log 하면 이전 작성자 확인

### 파일 추가하기
git add *filename*

git add .

*뭘 추가해야 할지 모를 땐? git status 누르면 알려줌

### Git commit (스냅샷 찍기)
git commit -m '*message*'
<!-- 지금 TIL은 remote add origin 할 필요 없음 -> clone 했기 때문-->

### Local Repo (내 컴퓨터) → Remote Repo (Github)

1. 리모트에 리포 만들기
2. 로컬한테 리모트의 존재를 알리기 remote
3. 밀기 

git remote add origin *URL*

git push origin main

git clone *URL*

(GitHub 같은 원격 저장소를 통째로 내 컴퓨터에 복사해오는 명령어)