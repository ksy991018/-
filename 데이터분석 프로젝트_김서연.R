#데이터 분석 준비

library(foreign)
library(dplyr)
library(readxl)
library(ggplot2)

raw_welfare <- read.spss(file="C:/r_data/easy_r/Koweps_hpc10_2015_beta1.sav", to.data.frame=T)
welfare <- raw_welfare

welfare <- rename(welfare,
                  sex=h10_g3,
                  birth=h10_g4,
                  marriage=h10_g10,
                  religion=h10_g11,
                  income=p1002_8aq1,
                  code_job=h10_eco9,
                  code_region=h10_reg7)

#1, 월급을 많이 받는 지역은 어디일까??


#변수 검토하기
class(welfare$code_region)
table(welfare$code_region)

class(welfare$income)
summary(welfare$income)


#전처리
welfare$code_region <- ifelse(welfare$code_region ==9999, NA, welfare$code_region)

table(is.na(welfare$code_region))

list_region <- data.frame(code_region = c(1:7), 
                          region = c("서울","수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))
list_region


welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

table(is.na(welfare$income))

#지역명 변수 추가
welfare <- left_join(welfare, list_region, id="code_region")

welfare %>% 
  filter(!is.na(code_region)) %>% 
  select(code_region, region) %>% 
  head(10)

region_income <- welfare %>% 
  filter(!is.na(region)&!is.na(income)) %>% 
  group_by(region) %>% 
  summarise(mean_income=mean(income))

region_income

#그래프 만들기
ggplot(data = region_income, aes(x=region, y=mean_income,fill=mean_income))+geom_col() + coord_flip()

#월급 높은순으로 그래프 정렬
ggplot(data = region_income, aes(x=reorder(region,-mean_income), y=mean_income,fill=mean_income))+geom_col() + coord_flip()


#2. 유교와 무교의 성비는 어떻게 될까? 

#변수 검토하기
class(welfare$religion)
table(welfare$religion)

class(welfare$sex)
table(welfare$sex)

#전처리
welfare$religion <- ifelse(welfare$religion==9, NA, welfare$religion)
table(is.na(welfare$religion))

welfare$sex <- ifelse(welfare$sex==9, NA, welfare$sex)
table(is.na(welfare$sex))

welfare$religion <- ifelse(welfare$religion==1, "Yes", "No")
table(welfare$religion)

welfare$sex <- ifelse(welfare$sex==1, "Male", "Female")
table(welfare$sex)

#변수 추가
religion_sex <- welfare %>% 
  group_by(religion,sex) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100),1)

religion_sex


#그래프 만들기
ggplot(data=religion_sex, aes(x=religion, y=pct, fill=sex)) + geom_col(position="dodge") +scale_x_discrete(limits=c("Yes", "No"))
