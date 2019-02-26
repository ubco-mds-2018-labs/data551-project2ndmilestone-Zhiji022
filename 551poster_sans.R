sans<- read.csv("/Users/jimmyding/Desktop/sans_country.csv", header=T)
head(sans)
colnames(sans)
library(ggplot2)

library(png)
library(countrycode)
library(ggmap)


world<-map_data("world")
world <- world[world$region != "Antarctica",]


for (i in 1:nrow(sans)) {
  latlon = geocode(as.character(sans[i,1]))
  sans$lon[i] = as.numeric(latlon[1])
  sans$lat[i] = as.numeric(latlon[2])
}

theme_set(theme_grey(base_size = 25))
map<-ggplot()+
  geom_map(data=sans,map=world, (aes(map_id = Country.Name)))
map                       

p <- map + geom_point(data = sans, aes(x = lon, y = lat, 
                     size=sans$Malaria.cases.reported), alpha = 0.3, 
                      size = 2.5,color="#336600")+
  labs(title = "Malaria cases reported")+
  transition_time(Year) +
  labs(title = "Year: {frame_time}")
  
animate(p)

# static graph

sans$Continent <- countrycode(sourcevar = sans[, "Country.Name"],
                              origin = "country.name",
                              destination = "continent")

sans_sub <- as.data.frame(cbind(as.character(sans$Country.Name[sans$Year=="2016"]), sans$Mortality.rate.attributed.to.unsafe.water..unsafe.sanitation.and.lack.of.hygiene..per.100.000.population.[sans$Year=="2016"],
                 sans$People.using.at.least.basic.sanitation.services....of.population.[sans$Year=="2015"],
                 sans$Population..total[sans$Year=="2015"]
                 ))


colnames(sans_sub) <- c("Country.Name", "Mortality.rate.attributed.to.unsafe.water..unsafe.sanitation.and.lack.of.hygiene..per.100.000.population.",
                        "People.using.at.least.basic.sanitation.services....of.population.","Population..total")

sans_sub$Continent <- countrycode(sourcevar = sans_sub[, "Country.Name"],
                              origin = "country.name",
                              destination = "continent")



theme_set(theme_classic(base_size = 20))
p <- ggplot(
  sans_sub, 
  aes(x = as.numeric(People.using.at.least.basic.sanitation.services....of.population.),
      y= as.numeric(Mortality.rate.attributed.to.unsafe.water..unsafe.sanitation.and.lack.of.hygiene..per.100.000.population.), 
      size = as.numeric(as.character(Population..total)), 
      colour = Continent),xlim=c(0,100), ylim=c(0,100)) +
  geom_point(show.legend = TRUE, alpha = 0.7) +
  scale_color_manual(values = c("purple", "blue", "red","green","orange","yellow")) +
  scale_size(range = c(1, 30)) +
  labs(x = "People using at least basic sanitation services (% of population)", 
       y = "Mortality rate attributed to water sanitation (per 100,000 population)",
       size = "Population Total",
       colour= "Continent")+ 
  scale_x_continuous(limits=c(0, 100))+
  scale_y_continuous(limits=c(0, 100))
  theme(legend.text = element_text(size = 10), 
        legend.title = element_text(size = 10))

ggsave("/Users/jimmyding/Desktop/sans.png",p, height = 10, width =15)

