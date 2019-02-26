sans_water<- read.csv("/Users/jimmyding/Desktop/sans_country.csv", header=T)
head(sans_water)
colnames(sans_water)
library(ggplot2)
library(gganimate)
library(gifski)
library(png)
library(countrycode)


sans_water$Continent <- countrycode(sourcevar = sans_water[, "Country.Name"],
                              origin = "country.name",
                              destination = "continent")

sans_water <- sans_water[sans_water$Year >= 2000, ]
sans_water

# Animated figure 1: life expectancy vs. neonatal motality

theme_set(theme_grey(base_size = 25))
p_anim <- ggplot(
  sans_water, 
  aes(x = People.using.at.least.basic.drinking.water.services....of.population., 
      y=People.practicing.open.defecation....of.population., 
      size = Population..total, colour = Continent)
) +
  geom_point(show.legend = TRUE, alpha = 0.7) +
  scale_color_manual(values = c("purple", "blue", "red","green","orange","yellow")) +
  scale_size(range = c(3, 30)) +
  labs(x = "People using at least basic drinking water services (% of population)", 
       y = "People practicing open defecation (% of population)")+
  theme(legend.text = element_text(size = 20), 
        legend.title = element_text(size = 25))+
  transition_time(Year) +
  labs(title = "Year: {frame_time}")

animate(p_anim, height = 800, width =1000)
anim_save("/Users/jimmyding/Desktop/aniplot2.gif")