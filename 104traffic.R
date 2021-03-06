install.packages("dplyr")
install.packages("ggplot2")
install.packages("viridis")
install.packages("ggthemes")

library(dplyr) #資料處理package
library(ggplot2) #視覺化package
library(viridis) #主題package
library(ggthemes) #配色package

data <- read.csv("traffic.csv",fileEncoding="big5",stringsAsFactors = F)

type <- data %>%
  filter(year == 104) %>%
  group_by(type) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))

vtype <- data %>%
  filter(year == 104) %>%
  group_by(vehicle_type) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))

method <- data %>%
  filter(year == 104) %>%
  group_by(method) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))


write.csv(type,file = "type.csv",row.names = F,fileEncoding="utf-8")
write.csv(vtype,file = "vtype.csv",row.names = F,fileEncoding="utf-8")
write.csv(method,file = "method.csv",row.names = F,fileEncoding="utf-8")

type_month <- data %>%
  filter(year == 104) %>%
  group_by(month,type) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))

vtype_month <- data %>%
  filter(year == 104) %>%
  group_by(month,vehicle_type) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))

method_month <- data %>%
  filter(year == 104) %>%
  group_by(month,method) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))


write.csv(type_month,file = "type_month.csv",row.names = F,fileEncoding="utf-8")
write.csv(vtype_month,file = "vtype_month.csv",row.names = F,fileEncoding="utf-8")
write.csv(method_month,file = "method_month.csv",row.names = F,fileEncoding="utf-8")


ggplot(type[1:5,],aes(x=type,y =count,fill = type))+
  geom_bar(stat="identity",width=.5,alpha = 0.8) +
  geom_text(aes(label = count),size = 3.5) +
  ggtitle("104年交通違規舉發件數")

ggplot(vtype,aes(x=vehicle_type,y =count,fill = vehicle_type))+
  geom_bar(stat="identity",width=.5,alpha = 0.8) +
  geom_text(aes(label = count),size = 3.5) +
  ggtitle("104年交通違規舉發車種別件數")

ggplot(method,aes(x=method,y =count,fill = method))+
  geom_bar(stat="identity",width=.5,alpha = 0.8) +
  geom_text(aes(label = count),size = 3.5) +
  ggtitle("104年交通違規舉發方式別件數")

top5type <- type[1:5,1]#取出數量前五的種類
top5 <- data.frame()#產生空的框架
for(i in 1:5){
  X <- type_month %>%
    filter(type == as.character(top5type[i,]))
  top5 <- rbind(top5,X)
}#重新取出數量前五種類的資料

ggplot(top5,aes(x=type,y =count,fill = type))+
  geom_boxplot(alpha = 0.7) +
  ggtitle("104年交通違規盒鬚圖")
#畫出盒鬚圖

bar <- list()#產生空的list
for(i in 1:12){
  X <- ungroup(top5) %>%
    filter(month == i)
  bar[[i]]<- ggplot(X,aes(x=type,y =count,fill = type))+
    geom_bar(stat="identity",width=.5,alpha = 0.8) +
    geom_text(aes(label = count),size = 3.5) +
    ggtitle(paste("104年",i,"月交通違規舉發"))
  print(bar[[i]] )
}#產生1至12月的bars

trendline <- list() 
for(i in 1:5){
   X <- ungroup(top5) %>%
    filter(type == as.character(top5type[i,]))
  trendline[[i]] <- ggplot(X,aes(x=month,y =count))+
    geom_text(aes(label = count),size = 3.5) +
    geom_line(colour = "darkred",size = 1,alpha=0.8) +
    scale_x_continuous(breaks = 1:12) +
    theme_bw() +
    ggtitle(paste("104年",as.character(top5type[i,]),"趨勢線"))
  print(trendline[[i]] )
}#產生前5種類的trendllines

month <- data %>%
  filter(year == 104) %>%
  group_by(month) %>%
  summarise(count = sum(count)) %>%
  arrange(desc(count))

ggplot(month,aes(x=month,y =count))+
  geom_text(aes(label = count),size = 3.5) +
  geom_line(colour = "darkred",size = 1,alpha=0.8) +
  scale_x_continuous(breaks = 1:12) +
  theme_bw() +
  ggtitle(paste("104年交通違規總數趨勢線"))

ggplot(vtype_month,aes(x=month,y =count,colour=vehicle_type))+
  geom_text(aes(label = count),size = 3.5) +
  geom_line(size = 1,alpha=0.8) +
  scale_x_continuous(breaks = 1:12) +
  theme_bw() +
  ggtitle(paste("104年交通違規車種趨勢線"))
  
  ggplot(method_month,aes(x=month,y =count,colour=method))+
  geom_text(aes(label = count),size = 3.5) +
  geom_line(size = 1,alpha=0.8) +
  scale_x_continuous(breaks = 1:12) +
  theme_bw() +
  ggtitle(paste("104年交通違規舉發方式趨勢線"))

ggplot(ungroup(top5),aes(x=factor(month), y=factor(type), fill=count)) +
 geom_tile(color="white", size=0.1) +
 scale_fill_viridis(name="件數")+ #使用viridis
 coord_equal()+
 labs(x=NULL, y=NULL, title="104年交通違規熱度圖")+
 theme_tufte(base_family="Helvetica")+ #使用ggthemes
 theme(plot.title=element_text(hjust=0))+
 theme(axis.ticks=element_blank())+
 theme(axis.text=element_text(size=7))+
 theme(legend.title=element_text(size=8))+
 theme(legend.text=element_text(size=6))
#熱度圖
