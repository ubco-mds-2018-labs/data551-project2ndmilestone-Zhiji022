hsys<- read.csv("/Users/jimmyding/Desktop/hsys_country.csv", header=T)
head(hsys)
colnames(hsys)
library(ggplot2)
library(gganimate)
library(gifski)
library(png)
library(countrycode)


hsys$Continent <- countrycode(sourcevar = hsys[, "Country.Name"],
                              origin = "country.name",
                              destination = "continent")


# Animated figure 1: life expectancy vs. neonatal motality

theme_set(theme_grey(base_size = 25))
p_anim <- ggplot(
  hsys, 
  aes(x = Mortality.rate..infant..per.1.000.live.births., y=Life.expectancy.at.birth..total..years., 
      size = Population..total, colour = Continent)
) +
  geom_point(show.legend = TRUE, alpha = 0.7) +
  scale_color_manual(values = c("purple", "blue", "red","green","orange","yellow")) +
  scale_size(range = c(3, 30)) +
  labs(x = "Infant Mortality (per 1000 births)", y = "Life expectancy (years)")+
  theme(legend.text = element_text(size = 20), 
        legend.title = element_text(size = 25))+
  transition_time(Year) +
  labs(title = "Year: {frame_time}")

animate(p_anim, height = 800, width =1000)
anim_save("/Users/jimmyding/Desktop/aniplot.gif")