#미국 코로나 환자의 주별 데이터
#Total cases에 대한 미국 지도의 interactive 단계구분도를 그려서 html로 저장

library(readxl)
uscorona_case<- as.data.frame(read_excel("C:/Users/KSY/Desktop/corona.xlsx"))
uscorona_case

library(ggiraphExtra)
str(uscorona_case)
head(uscorona_case)

library(tibble)
uscorona_case$State <- tolower(uscorona_case$State)
str(uscorona_case)

library(ggplot2)
states_map <- map_data("state")
str(states_map)

ggChoropleth(data=uscorona_case,
             aes(fill=Case,
                 map_id=State),
             map=states_map,
             interactive=T)
