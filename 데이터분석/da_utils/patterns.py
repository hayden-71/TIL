import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns # 히트맵은 여기 있음!
from IPython.display import display

import warnings
warnings.filterwarnings('ignore')

# 한글 폰트 설정 (선택사항)
plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False


def analyze_missing_patterns(df: pd.DataFrame):
    """결측값 패턴 종합 분석"""
    print('===결측값 패턴 분석===')
    missing_info = df.isna().sum()
    missing_pct = (missing_info / len(df)) * 100
    missing_summary = pd.DataFrame({
        '결측수': missing_info,
        '결측률(%)': missing_pct.round(2)
    })

    # 결측값이 0보다 클 때, 많은 순서대로 정렬
    missing_summary = missing_summary[missing_summary['결측수'] > 0].sort_values('결측수', ascending=False)
    print('변수별 결측 현황')
    display(missing_summary)




    # 결측값 시각화 하기~~~
    fig, axes = plt.subplots(2, 2, figsize = (15, 10))
    a1, a2, a3, a4 = axes[0,0], axes[0,1], axes[1,0], axes[1,1]
 

    # 1. 결측값 히트맵
               # 인자 설정(결측값), y라벨 안보이게, 컬러 바, 컬러 맵
    sns.heatmap(df.isna(), yticklabels=False, cbar=True, cmap='viridis', ax=a1)
    a1.set_title('결측값 패턴 히트맵')


    # 2. 변수별 결측률 바 차트
    if len(missing_summary): # missing_summary에서 길이가 0이면 false니까 실행 안될거고, 그 외엔 진행 되니까 : 이렇게만 써도 됨!!
        missing_summary['결측률(%)'].plot(kind='bar', color='coral', ax=a2)
        a2.set_title('변수별 결측률')
        a2.set_ylabel('결측률(%)')
        a2.tick_params(axis='x', rotation=0)


    # 3. 결측갑 조합 패턴 -> 결측이 동시에 발생하는 변수들을 파악 -> 유의미하게 많으면 연관을 추정해볼 수 있다 -> 그룹별 처리 전략을 쓸 수 있다

                # df.컬럼 중에서 [결측값이, 하나라도 있으면] df 재구성! 하고 T/F 표시
    missing_pattern = df[df.columns[df.isna().any()]].isna()

    if len(missing_pattern):
        # 결측 패턴 조합 상위 10개       # count 되어서 자동으로 정렬
        pattern_counts = missing_pattern.value_counts().head(10)
        pattern_counts.plot(kind='bar', color='lightblue', ax=a3)
        a3.set_title('결측 패턴 조합(상위10)')
        a3.set_ylabel('빈도')
        a3.tick_params(axis='x', rotation=45)



    # 4. 결측 변수별 결측 여부(0/1)와 다른 수치형 변수 간 상관관계 히트맵 시각화    <-여기 다시 보기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    numeric_cols = df.select_dtypes(include='number').columns.tolist()
    missing_cols = df.columns[df.isna().any()].tolist()

    if len(numeric_cols) > 0 and len(missing_cols) > 0:
        # 결측값을 0/1로 변환한 DataFrame 생성
        missing_binary = df[missing_cols].isna().astype(int)
        missing_binary.columns = [f'{col}_missing' for col in missing_binary.columns]
        
        # 수치형 변수와 결측 패턴 변수 결합
        corr_data = pd.concat([df[numeric_cols], missing_binary], axis=1)
        
        # 상관계수 계산
        correlation_matrix = corr_data.corr()
        
        # 결측 패턴 변수와 수치형 변수 간의 상관관계만 추출
        missing_numeric_corr = correlation_matrix.loc[
            missing_binary.columns, 
            numeric_cols
        ]
        
        # 상관관계가 있는 경우에만 히트맵 그리기
        if missing_numeric_corr.shape[0] > 0 and missing_numeric_corr.shape[1] > 0:
            sns.heatmap(missing_numeric_corr, 
                    annot=True, 
                    cmap='coolwarm', 
                    center=0,
                    fmt='.2f',
                    ax=a4,
                    cbar_kws={'label': '상관계수'})
            a4.set_title('결측 패턴과 수치형 변수 간 상관관계')
            a4.set_xlabel('수치형 변수')
            a4.set_ylabel('결측 패턴')
        else:
            a4.text(0.5, 0.5, '분석할 상관관계 없음', ha='center', va='center')
            a4.axis('off')
    else:
        a4.text(0.5, 0.5, '수치형 변수 또는\n결측값이 없음', ha='center', va='center')
        a4.axis('off')

        

    plt.tight_layout()
    plt.show()

    return missing_summary

