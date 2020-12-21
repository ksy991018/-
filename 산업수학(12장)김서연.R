#한민국의 코로나 total cases에 대한 시계열 그래프를 그려서 html로 저장


library(dygraphs)
library(readxl)
korea_case<- as.data.frame(read_excel("C:/Users/KSY/Desktop/Korea.xlsx"))
head(korea_case)
str(korea_case)

library(xts)
corona <- xts(korea_case$Total_Case, order.by=korea_case$Date)
head(corona)
dygraph(corona) %>% dyRangeSelector()

Sys.setenv(TZ = "UTC")

