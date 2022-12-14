#copy data from excel and run this commend
cookie_cats <- read.table(file = "clipboard",sep = "\t", header=TRUE)
 

#miss value
library(naniar)
n_miss(cookie_cats)


#duplicate 
library(dplyr)
duplicated(cookie_cats)
distinct(cookie_cats,userid, .keep_all= TRUE)


#sum playser play after 1 || 7 days
sum=0
for (i in 1: length(cookie_cats$retention_1)){
if(cookie_cats$retention_1[i]=="TRUE"||cookie_cats$retention_7[i]=="TRUE")sum=sum+1}
sum


#convert from ch to bool
for (i in 1: length(cookie_cats$retention_1)){
if(cookie_cats$retention_1[i]=="TRUE")
cookie_cats$retention_1[i]=TRUE
else cookie_cats$retention_1[i]=FALSE
if(cookie_cats$retention_7[i]=="TRUE")
cookie_cats$retention_7[i]=TRUE
else cookie_cats$retention_7[i]=FALSE}


# geom bar between retention_7 and retention_1
library(ggplot2)
ggplot(cookie_cats,aes(retention_1,fill=retention_7))+geom_bar()


#summary for each variable
summary(cookie_cats[])


#count players in gate 30,40
length(cookie_cats$version[cookie_cats$version=="gate_30"])#44700
length(cookie_cats$version[cookie_cats$version=="gate_40"])#45489



#plot game round and 1:100 game roound
plot(cookie_cats$userid,cookie_cats$version)# all data
plot(cookie_cats$userid,cookie_cats$version[cookie_cats$version<=100])#1 to 100



#percentatge retenion1 and 7
cookie_cats %>% 
    group_by( retention_1 ) %>% 
    summarise( percent = 100 * n() / nrow( cookie_cats ) )
cookie_cats %>% 
    group_by( retention_7 ) %>% 
    summarise( percent = 100 * n() / nrow( cookie_cats ) )



#percentatge at 30,40 A/B
data1<-cookie_cats%>%
filter(version=="gate_30")

data2<-cookie_cats%>%
filter(version=="gate_40")

data1 %>% 
    group_by( retention_1 ) %>% 
    summarise( percent = 100 * n() / nrow(data1 ) )

data1 %>% 
    group_by( retention_7 ) %>% 
    summarise( percent = 100 * n() / nrow( data1 ) )

data2 %>% 
    group_by( retention_1 ) %>% 
    summarise( percent = 100 * n() / nrow(data2 ) )

data2 %>% 
    group_by( retention_7 ) %>% 
    summarise( percent = 100 * n() / nrow( data2 ) )
    
    
    
    
 library(infer)

library(dplyr)
    
    
    #botistrabing day 1
    
    #null distribution 
dis<-cookie_cats%>%
     specify(retention_1~ version ,success = "TRUE")%>%
     hypothesize(null="independence")%>%
     generate(reps=500,type = "permute")%>%
     calculate(stat="diff in props",order=c("gate_30","gate_40"))
#observed
 observed<-cookie_cats%>%
     group_by(version)%>%
     summarize(prop=mean(retention_1 ==TRUE))%>%
     summarize(diff(prop))
#visualize observed in null dis..
 dis%>%
 visualize()+
 shade_p_value(observed,direction = "right")
 #p-value
 dis%>%
 get_p_value(observed,direction = "right")#0.96
 
 
 
 

    #botisrabing day 7
   
    #null distribution 
dis<-cookie_cats%>%
     specify(retention_7~ version ,success = "TRUE")%>%
     hypothesize(null="independence")%>%
     generate(reps=500,type = "permute")%>%
     calculate(stat="diff in props",order=c("gate_30","gate_40"))
#observed
 observed<-cookie_cats%>%
     group_by(version)%>%
     summarize(prop=mean(retention_7 ==TRUE))%>%
     summarize(diff(prop))
#visualize observed in null dis..
 dis%>%
 visualize()+
 shade_p_value(observed,direction = "right")
 #p-value
 dis%>%
 get_p_value(observed,direction = "right")#1
 
 
 
 #conclusion
 #p-val on day1 is 0.97
 #p-val in day7 is 1
 #and shouldn't move lock from 30 to 40,buz p-value is huGGGGe
 
 
 


