library(stringr)
library(rvest)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(tidytext)

setwd("C:/Users/Benjamin/Downloads/onomastique")

stopwprds <- read.csv("french_stopwords.txt")
stopwprds <- unique(stopwprds)
##### PREPARATIONS DES FICHIERS DE BASE POUR LE NETTOYAGE
mots<-read.csv("mots.txt",encoding = "UTF-8",sep="\n",header = FALSE) #Ce fichier est un dictionnaire très complet de mots incluant les formes verbales de la langue française
mots<-as.data.frame(mots)
colnames(mots)<-c("title")
mots$title<-iconv(mots$title,from="UTF-8",to="ASCII//TRANSLIT")
mots<-unique(mots$title)
mots<-as.data.frame(mots)
colnames(mots)<-c("title")

prenoms<-read.csv("prenoms.csv",sep=";") #Ce fichier est un dictionnaire très complet de prénoms
prenoms<-prenoms[,1]
prenoms<-iconv(prenoms,to="ASCII//TRANSLIT")
prenoms<-as.data.frame(prenoms)
colnames(prenoms)<-c("title")
prenoms$title<-tolower(prenoms$title)

villes<-read.csv("villes.txt",encoding = "UTF-8",sep="\n",header = FALSE) #Ce fichier est un dictionnaire très complet de mots incluant les formes verbales de la langue française
villes<-as.data.frame(villes)
colnames(villes)<-c("title")
villes$title<-iconv(villes$title,from="UTF-8",to="ASCII//TRANSLIT")
villes<-unique(villes$title)
villes<-as.data.frame(villes)
colnames(villes)<-c("title")
villes$title<-tolower(villes$title)

pays<-read.csv("pays.txt",encoding = "UTF-8",sep="\n",header = FALSE) #Ce fichier est un dictionnaire très complet de mots incluant les formes verbales de la langue française
pays<-as.data.frame(pays)
colnames(pays)<-c("title")
pays$title<-iconv(pays$title,from="UTF-8",to="ASCII//TRANSLIT")
pays<-unique(pays$title)
pays<-as.data.frame(pays)
colnames(pays)<-c("title")
pays$title<-tolower(pays$title)
######

texte<-as.character(read.csv("texte.txt", encoding = "UTF-8"))
texte<-tolower(texte) #Homogénéisation du texte : suppression de la casse
texte<-str_replace_all(texte,"[:punct:]"," ")
texte<-str_replace_all(texte,"[:digit:]"," ")
texte<-str_replace_all(texte,"\n"," ")
texte<-str_replace_all(texte,"\t"," ")
for (i in 1:100) 
{
  texte<-str_replace_all(texte,"  "," ")
}


texte1<-as.data.frame(str_split(texte," "))
colnames(texte1)<-c("title")
texte1$title<-iconv(texte1$title,from="UTF-8",to="ASCII//TRANSLIT")

texte2<-unique(anti_join(texte1,mots,by="title"))
texte2<-as.data.frame(texte2[order(texte2$title),])
colnames(texte2)<-c("title")
texte3<-as.data.frame(texte2[str_length(texte2$title)>3 ,])
colnames(texte3)<-c("title")

texte4<-anti_join(texte3,prenoms,by="title")
texte4<-anti_join(texte3,villes,by="title")
texte4<-anti_join(texte3,pays,by="title")

write.csv(texte4,"index.csv")

